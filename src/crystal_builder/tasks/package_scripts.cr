@[Barista::BelongsTo(QuickBuilder)]
@[Barista::BelongsTo(FullBuilder)]
class Tasks::PackageScripts < Barista::Task
  include Common::Task

  @@name = "package-scripts"

  file("postinst", "#{__DIR__}/../../templates/postinst.hbs")
  file("postrm", "#{__DIR__}/../../templates/postrm.hbs")

  def build : Nil
    mkdir(target, parents: true)
    %w[postinst postrm].each do |file|
      template(
        src: file(file),
        dest: File.join(target, file),
        mode: File::Permissions.new(0o755),
        vars: {
          "install_dir" => install_dir
        },
        string: true
      )
    end
  end

  def target
    File.join(smart_install_dir, ".package-scripts")
  end

  def configure : Nil
    license("Apache-2.0")
    virtual(true)
    version(finder.crystal_version)
  end
end
