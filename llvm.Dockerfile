FROM quay.io/pypa/manylinux2014_x86_64

# install tinfo and zlib
RUN curl https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.2.tar.gz -o $HOME/ncurses.tar.gz && \
    curl https://zlib.net/zlib-1.2.11.tar.gz -o $HOME/zlib.tar.gz  && \
    tar xf $HOME/zlib.tar.gz  -C $HOME && \
    tar xf $HOME/ncurses.tar.gz  -C $HOME && \
    cd $HOME/zlib-1.2.11 && \
    CFLAGS=-fPIC ./configure && \
    make -j2 && make install && \
    cd $HOME/ncurses-6.2 && \
    CFLAGS=-fPIC ./configure --with-termlib && \
    make -j2 && make install && \
    rm -rf $HOME/zlib-1.2.11 && \
    rm -rf $HOME/ncurses-6.2 && \
    rm $HOME/zlib.tar.gz $HOME/ncurses.tar.gz

#install llvm
RUN curl https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-project-11.0.0.tar.xz -o $HOME/llvm.tar.xz && \
    tar xf $HOME/llvm.tar.xz -C $HOME && \
    mkdir $HOME/llvm_root && \
    cd $HOME/llvm-project-11.0.0 && mkdir build && cd build && \
    cmake -DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly' -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/llvm_root ../llvm && \
    make -j2 && make -j2 install && \
    rm -rf $HOME/llvm-project-11.0.0 && rm $HOME/llvm.tar.gz

ENV LLVM_ROOT=$HOME/llvm_root
