module Common::Task
  include Barista::Behaviors::Omnibus::Task

  getter :finder

  def initialize(project, *, callbacks = Barista::Behaviors::Omnibus::CacheCallbacks.new, @finder : VersionFinder)
    super(project, callbacks)
  end

  # Updates a target source folder with the version of config guess
  # present in Tasks::ConfigGuess
  def update_config_guess(target : String = ".", install : Array(Symbol) = %i[config_guess config_sub])
    unless dependencies.includes?(Tasks::ConfigGuess)
      raise "Please make ConfigGuess a dependency when using this method"
    end

    config_guess_dir = File.join(install_dir, "embedded", "lib", "config_guess")
    dest = File.join(source_dir, target)

    mkdir(dest, parents: true)

    copy("#{config_guess_dir}/config.guess", dest) if install.includes?(:config_guess)
    copy("#{config_guess_dir}/config.sub", dest) if install.includes?(:config_sub)
  end

  def sync_source
    mkdir("#{smart_install_dir}/sources/#{name}", parents: true)
    sync("#{source_dir}", "#{smart_install_dir}/sources/#{name}")
  end
end
