@[Barista::BelongsTo(CrystalBuilder)]
class Tasks::Libiconv < Barista::Task
  include Common::Task

  @@name = "libiconv"

  dependency ConfigGuess

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

    update_config_guess(target: "build-aux")
    update_config_guess(target: "libcharset/build-aux")

    command("./configure --prefix=#{install_dir}/embedded", env: env)
    command("make -j 3", env: env)
    command("make -j 3 install", env: env)
  end

  def configure :  Nil
    version("1.15")
    license("LGPL-2.1")
    license_file("COPYING.LIB")
    source("https://ftp.gnu.org/pub/gnu/libiconv/libiconv-#{version}.tar.gz",
      sha256: "ccf536620a45458d26ba83887a983b96827001e92a13847b45e4925cc8913178")\
  end
end
