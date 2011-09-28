require 'formula'

class Riak < Formula
  url 'http://downloads.basho.com/riak/riak-1.0.0rc2/riak-1.0.0rc2.tar.gz'
  homepage 'http://wiki.basho.com/Riak.html'
  md5 '40101a6b0e7d39a48f4c6686440aab14'

  head 'https://github.com/basho/riak.git'

  skip_clean 'libexec/log'
  skip_clean 'libexec/log/sasl'
  skip_clean 'libexec/data'
  skip_clean 'libexec/data/dets'
  skip_clean 'libexec/data/ring'

  depends_on 'erlang'

  def install
    ENV.deparallelize
    system "make all rel"
    %w(riak riak-admin).each do |file|
      inreplace "rel/riak/bin/#{file}", /^RUNNER_BASE_DIR=.+$/, "RUNNER_BASE_DIR=#{libexec}"
    end

    # Install most files to private libexec, and link in the binaries.
    libexec.install Dir["rel/riak/*"]
    bin.mkpath
    ln_s libexec+'bin/riak', bin
    ln_s libexec+'bin/riak-admin', bin

    (prefix + 'data/ring').mkpath
    (prefix + 'data/dets').mkpath

    # Install man pages
    man1.install Dir["doc/man/man1/*"]
  end
end
