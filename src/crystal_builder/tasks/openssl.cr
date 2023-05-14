@[Barista::BelongsTo(FullBuilder)]
class Tasks::OpenSSL < Barista::Task
  include Common::Task

  @@name = "openssl"

  dependency Cacerts

  file("no_docs_patch", "#{__DIR__}/../patches/openssl/no-docs.patch")

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path)

    prefix = if {% flag?(:linux) %} && kernel.machine == "s390x"
      "./Configure linux64-s390x -DOPENSSL_NO_INLINE_ASM"
    elsif platform.family == "raspbian"
      "./Configure linux-generic32"
    else
      "./config"
    end

    config_cmd = "#{prefix} disable-gost"

    command("#{config_cmd} #{config_args(env).join(" ")}", env: env)

    patch(file("no_docs_patch"), string: true, env: env)
    command("make depend", env: env)
    command("make", env: env)
    command("make install", env: env)
  end

  def config_args(env)
    args = [
      "--prefix=#{smart_install_dir}/embedded",
      "--openssldir=#{install_dir}/embedded/ssl",
      "no-comp",
      "no-idea",
      "no-mdc2",
      "no-rc5",
      "no-ssl2",
      "no-ssl3",
      "no-zlib",
      "shared",
    ]
    args << env["CFLAGS"]
    args << env["LDFLAGS"]
    args
  end

  def configure :  Nil
    license("OpenSSL")
    license_file("LICENSE")
    version("1.1.1")
    source("https://ftp.openssl.org/source/old/#{version}/openssl-#{version}l.tar.gz")
    preserve_symlinks(false)
  end
end
