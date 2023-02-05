class Physfs < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://github.com/icculus/physfs/archive/refs/tags/release-3.2.0.tar.gz"
  sha256 "1991500eaeb8d5325e3a8361847ff3bf8e03ec89252b7915e1f25b3f8ab5d560"
  license "Zlib"
  head "https://github.com/icculus/physfs.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "5289a7a059e6638be3396173eb9a84469d0215c10586b8694c71dd610471a056"
    sha256 cellar: :any,                 arm64_monterey: "cab1caaa3f55144dbadb72e9a959862b33acd2901b2adb7231818e293a0b5d28"
    sha256 cellar: :any,                 arm64_big_sur:  "065d120b86dd681aa4fb20c874456b1fbbae3b8428e2051cea9f49b9da01dceb"
    sha256 cellar: :any,                 ventura:        "aaa2c912d9d4d5fb959a9d9940ddcc1efeb655f2f2c65958978828f31bb9d98c"
    sha256 cellar: :any,                 monterey:       "4d466b0a2b62169961a13f0f88e0392dd5662ecbfed5e9efa39ef5375b22f284"
    sha256 cellar: :any,                 big_sur:        "f2348a828a9f32b6fdb78278c5ecd86c7f7bb4abf27032478b44cd4db6338b0c"
    sha256 cellar: :any,                 catalina:       "be794e8986be384f98e3d4d14a4fe3830428084febea0caff4bba5c363e890c6"
    sha256 cellar: :any,                 mojave:         "03f4a5a5ed440e3b39e91af11ac4470f07ce742f844d188bca3e58becfd24f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9be8022f4ef1cc79e8bbf71a4df0c7589ace1162f316b6c481f49ce8c67d3dc"
  end

  depends_on "cmake" => :build

  uses_from_macos "zip" => :test

  on_linux do
    depends_on "readline"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPHYSFS_BUILD_TEST=TRUE",
                    "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.txt").write "homebrew"
    system "zip", "test.zip", "test.txt"
    (testpath/"test").write <<~EOS
      addarchive test.zip 1
      cat test.txt
    EOS
    output = shell_output("#{bin}/test_physfs < test 2>&1")
    expected = if OS.mac?
      "Successful.\nhomebrew"
    else
      "Successful.\n> cat test.txt\nhomebrew"
    end
    assert_match expected, output
  end
end
