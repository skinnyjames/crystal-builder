@[Barista::BelongsTo(CrystalBuilder)]
class Tasks::LibPCRE2 < Barista::Task
  include Common::Task

  @@name = "libpcre2"

  # dependency Libtool

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

    command("./configure --prefix=#{install_dir}/embedded --disable-shared --disable-cpp --enable-jit --enable-utf --enable-unicode-properties", env: env)
    command("./make", env: env)
  end

  def configure : Nil
    version("10.42")
    license("BSD")
    license_file("LICENCE")
    source("https://github.com/PCRE2Project/pcre2/releases/download/pcre2-#{version}/pcre2-#{version}.tar.gz")
  end
end
