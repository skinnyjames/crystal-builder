@[Barista::BelongsTo(CrystalBuilder)]
class Tasks::LLVM < Barista::Task
  include Common::Task

  @@name = "llvm"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

    mkdir(build_dir, parents: true)
    command("cmake  -DLLVM_ENABLE_PROJECTS='clang;lld' -DCMAKE_INSTALL_PREFIX=#{install_dir}/embedded -G 'Unix Makefiles' ../llvm", env: env, chdir: build_dir)
    command("make", env: env)
  end

  def build_dir
    File.join(source_dir, "build")
  end

  def configure : Nil
    license("Apache-2.0")
    license_file("LICENSE.TXT")
    version("16.0.0")
    source("https://github.com/llvm/llvm-project/releases/tag/llvmorg-#{version}")
  end
end
