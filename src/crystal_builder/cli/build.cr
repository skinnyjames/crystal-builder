class Cli::Build < ACON::Command
  include Barista::Behaviors::Software::OS::Information

  @@default_name = "build"

  getter :projects

  def initialize(@projects : Hash(String, Common::Project))
    super()
  end

  protected def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
    version = (input.argument("crystal-version", String?) || "master")
    type = input.option("type", String?) || "quick"
    prefix = input.option("prefix") || "/opt/crystal"
    workers = (input.option("workers", Int32?) || available_cpus)
    with_interpreter = true
    clean = input.option("clean", Bool?) == true

    project = {
      "full" => projects["crystal-full"],
      "quick" => projects["crystal-quick"],
      "static" => projects["crystal-static"]
    }[type]

    begin
      project.build(version, with_interpreter: with_interpreter, workers: workers, prefix: prefix, clean_existing: clean)
      
      ACON::Command::Status::SUCCESS
    rescue ex
      output.puts("<error>Build failed: #{ex.message}</error>")
      ACON::Command::Status::FAILURE
    end
  end

  def configure : Nil
    self
      .description("Builds a Crystal package")
      .argument("crystal-version", :optional, "The version of Crystal to build from source (default `master`)")
      .option("type", "t", :optional, "Type of build <quick|full|static> (default quick)")
      .option("workers", "w", :optional, "The number of concurrent build workers to use (default #{available_cpus})")
      .option("prefix", "p", :optional, "The directory to where the package will be installed to")
      .option("clean", "c", :none, "Cleans current install before building")
  end

  private def available_cpus
    memory.cpus.try(&.-(1)) || 1
  end
end
