@[Barista::BelongsTo(CrystalBuilder)]
class Tasks::Liblzma < Barista::Task
  include Common::Task

  @@name = "liblzma"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))
    command(config_command.join(" "), env: env)
    command("make install", env: env)
  end

  def config_command
    [
      "./configure",
      "--prefix=#{install_dir}/embedded",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-doc",
      "--disable-scripts"
    ]
  end

  def configure : Nil
    version("5.4.0")
    license("Public-Domain")
    source("http://tukaani.org/xz/xz-#{version}.tar.gz",
      md5: "5a18dfa981af3fab3d26eb95f1ded823")
  end
end
