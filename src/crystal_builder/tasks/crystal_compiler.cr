@[Barista::BelongsTo(CrystalBuilder)]
class Tasks::CrystalCompiler < Barista::Task
  include Common::Task
  
  @@name = "crystal"

  dependency BdwGC
  dependency LibCMusl
  dependency LibGMP
  dependency LibPCRE2
  dependency LibXML2
  dependency LibYAML

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path)

    mkdir("#{smart_install_dir}/bin", parents: true)
    command("make")
    command("make std_spec compiler_spec")
    command("cp bin/crystal #{smart_install_dir}/bin/crystal")
  end

  def configure : Nil
    version(finder.crystal_version)
    license("Apache-2.0")
    license_file("LICENSE")
    source("https://github.com/crystal-lang/crystal/archive/#{version}.tar.gz")
  end
end
