@[Barista::BelongsTo(FullBuilder)]
class Tasks::LibXML2 < Barista::Task
  include Common::Task

  @@name = "libxml2"

  dependency Zlib
  dependency Libiconv
  dependency Liblzma
  dependency ConfigGuess

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

    cmd = [
      "./configure",
      "--prefix=#{install_dir}/embedded",
      "--with-zlib=#{install_dir}/embedded",
      "--with-iconv=#{install_dir}/embedded",
      "--with-lzma=#{install_dir}/embedded",
      "--without-python",
      "--without-icu"
    ]

    update_config_guess

    command(cmd.join(" "), env: env)
    command("make", env: env)
    command("make install", env: env)
  end

  def configure :  Nil
    license("MIT")
    license_file("Copyright")
    version("2.10.3")
    source("https://download.gnome.org/sources/libxml2/2.10/libxml2-#{version}.tar.xz",
      sha256: "5d2cc3d78bec3dbe212a9d7fa629ada25a7da928af432c93060ff5c17ee28a9c")
  end
end
