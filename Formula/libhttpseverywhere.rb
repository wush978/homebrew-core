class Libhttpseverywhere < Formula
  desc "Bring HTTPSEverywhere to desktop apps"
  homepage "https://github.com/gnome/libhttpseverywhere"
  url "https://download.gnome.org/sources/libhttpseverywhere/0.4/libhttpseverywhere-0.4.6.tar.xz"
  sha256 "a58e2afbaf269fdb22bc1c11f240c5fd63c2dd9918125b529e3d826d88df7db2"

  bottle do
    cellar :any
    sha256 "530bec16b2d2c7ce4d7ebac961ab4eb87494b6d09564211ed306933c7271443c" => :sierra
    sha256 "c39ab5c63bb26cf864d9edc27046b9db65e647e326a99d4baa797bdbf5466595" => :el_capitan
    sha256 "80016b3ae3ddae82c75cc6723bb71673cba2a98bbac3fb97409c56edd2d40677" => :yosemite
    sha256 "e1ef20c68dc2a7c7ab121f9116d7e6518470b058abeb81958032bd120aeb0e92" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "vala" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "libgee"
  depends_on "libarchive"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "test"
      system "ninja", "install"
    end

    dir = [Pathname.new("#{lib}64"), lib/"x86_64-linux-gnu"].find(&:directory?)
    unless dir.nil?
      mkdir_p lib
      system "/bin/mv", *Dir[dir/"*"], lib
      rmdir dir
      inreplace Dir[lib/"pkgconfig/*.pc"], %r{lib64|lib/x86_64-linux-gnu}, "lib"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <httpseverywhere.h>

      int main(int argc, char *argv[]) {
        GType type = https_everywhere_context_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    libarchive = Formula["libarchive"]
    libgee = Formula["libgee"]
    libsoup = Formula["libsoup"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/httpseverywhere-0.4
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libarchive.opt_include}
      -I#{libgee.opt_include}/gee-0.8
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{libarchive.opt_lib}
      -L#{libgee.opt_lib}
      -L#{libsoup.opt_lib}
      -L#{lib}
      -larchive
      -lgee-0.8
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lhttpseverywhere-0.4
      -ljson-glib-1.0
      -lsoup-2.4
      -lxml2
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
