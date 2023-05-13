@[Barista::BelongsTo(CrystalBuilder)]
class Tasks::LibEvent < Barista::Task
  include Common::Task

  @@name = "libevent"

  # dependency Libtool
  dependency OpenSSL

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))
    env["ACLOCAL_PATH"] = File.join(install_dir, "embedded", "share", "aclocal")

    command("./autogen.sh", env: env)
    command("./configure --prefix=#{install_dir}/embedded --disable-openssl", env: env)
    command("make", env: env)
    command("make install", env: env)
  end

  def configure :  Nil
    license("BSD-3-Clause")
    license_file("LICENSE")
    version("2.1.12")
    source("https://github.com/libevent/libevent/releases/download/release-#{version}-stable/libevent-#{version}-stable.tar.gz")
  end
end
