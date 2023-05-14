module Common::Project
  include Barista::Behaviors::Omnibus::Project
  
  def root
    __DIR__
  end

  # defer install directory until we get cli args
  def initialize
    barista_dir("/opt/barista")
    install_dir("/opt/crystal")
    license("Apache-2.0")
    license_content(file("apache_license"))
    replace("crystal")
    conflict("crystal")
    package_user("root")
    package_group("root")
    package_scripts_path(File.join(install_dir, ".package-scripts"))
    maintainer("Sean Gregory <sean.christopher.gregory@gmail.com>")
    homepage("https://github.com/skinnyjames/crystal_builder")

    if ENV["USE_CACHE"]? == "true" || !ENV["CI"]?
      cache(true)

      prefix = [
        "crystal",
        platform.family,
        kernel.machine.gsub(/\s/, "_")
      ].join("-")

      cache_tag_prefix(prefix)
    end

    configure_excludes
  end

  def build(
    version : String,
    *, 
    with_interpreter : Bool,
    workers : Int32, 
    clean_existing : Bool,
    prefix : String = "/opt/crystal",
    finder : VersionFinder = Version.new(version, with_interpreter)
  )

    Log.setup_from_env

    install_dir(prefix)

    clean! if clean_existing

    FileUtils.mkdir_p(log_directory)

    build_version(finder.crystal_version)
    setup_tasks(finder)
    orchestrate(workers)

    packager
      .on_output { |str| puts str }
      .on_error { |str| puts str}
      .run
  end

  private def orchestrate(workers)
    orchestration = orchestrator(workers: workers)
        
    orchestration.on_task_start do |task|
      Barista::Log.info(task) { "starting build" }

      file_map[task] = File.new("#{log_directory}/#{task}.log", "w")
    end

    orchestration.on_task_failed do |task, ex|
      Barista::Log.error(task) { "build failed: #{ex}" }
    end

    orchestration.on_task_succeed do |task|
      Barista::Log.info(task) { "build succeeded" }
    end

    orchestration.on_task_finished do |task|
      file_map[task].try(&.close)
      file_map.delete(task)
    end

    orchestration.on_unblocked do |info|
      str = <<-EOH
      Unblocked #{info.unblocked.join(", ")}
      Building #{info.building.join(", ")}
      Active Sequences #{info.active_sequences.map {|k,v| "{ #{k}, #{v} }"}.join(", ")}
      EOH
      Barista::Log.info(name) { str }
    end

    orchestration.execute
  end

  private def file_map : Hash(String, File)
    @file_map ||= {} of String => File
  end

  private def setup_tasks(finder : VersionFinder) : Nil
    colors = Barista::ColorIterator.new

    Log.setup_from_env

    tasks.each do |task_klass|
      logger = Barista::RichLogger.new(colors.next, task_klass.name)

      task = task_klass.new(self, callbacks: callbacks, finder: finder)

      task.on_output do |str|
        logger.debug { str }

        file_map[task.name].try(&.puts(str))
      end

      task.on_error do |str|
        logger.error { str }

        file_map[task.name].try(&.puts(str))
      end
    end
  end

  def log_directory
    "#{barista_dir}/log"
  end

  private def callbacks : Barista::Behaviors::Omnibus::CacheCallbacks
    callbacks = Barista::Behaviors::Omnibus::CacheCallbacks.new
    callbacks.fetch do |cacher|
      dir = Dir.tempdir
      cache_path = File.join("/cache", "crystal", cacher.filename)
      begin
        if File.exists?(cache_path)
          FileUtils.cp_r(cache_path, dir)
          cacher.unpack(File.join(dir, cacher.filename))
        else
          false
        end
      rescue ex
        false
      end
    end

    callbacks.update do |task, path|
      FileUtils.mkdir_p("/cache/crystal") unless Dir.exists?("/cache/crystal")
      FileUtils.cp(path, File.join("/cache", "crystal", "#{task.tag}.tar.gz"))
      true
    end

    callbacks
  end

  private def configure_excludes
    exclude("\.git*")
    exclude("\.package-scripts")
  end
end
