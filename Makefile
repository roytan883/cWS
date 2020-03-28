CPP_SHARED := -DUSE_LIBUV -std=c++17 -O3 -I ./src -shared -fPIC ./src/Extensions.cpp ./src/Group.cpp ./src/Networking.cpp ./src/Hub.cpp ./src/cSNode.cpp ./src/WebSocket.cpp ./src/HTTPSocket.cpp ./src/Socket.cpp ./src/Epoll.cpp ./src/Addon.cpp
CPP_OSX := -stdlib=libc++ -mmacosx-version-min=10.7 -undefined dynamic_lookup

VER_57 := v8.17.0
VER_59 := v9.11.2
VER_64 := v10.18.0
VER_67 := v11.15.0
VER_72 := v12.14.0
VER_79 := v13.10.1

# this is temporary support for Node 13.8 and lower (will be removed when more Node versions come)
VER_79_8 := v13.8.0

default:
	make targets
	NODE=targets/node-$(VER_57) ABI=57 make `(uname -s)`
	NODE=targets/node-$(VER_59) ABI=59 make `(uname -s)`
	NODE=targets/node-$(VER_64) ABI=64 make `(uname -s)`
	NODE=targets/node-$(VER_67) ABI=67 make `(uname -s)`
	NODE=targets/node-$(VER_72) ABI=72 make `(uname -s)`
	NODE=targets/node-$(VER_79) ABI=79 make `(uname -s)`
	# this is temporary support for Node 13.8 and lower (will be removed when more Node versions come)
	NODE=targets/node-$(VER_79_8) ABI=79_8 make `(uname -s)`
	for f in dist/bindings/*.node; do chmod +x $$f; done
targets:
	mkdir targets
	curl https://nodejs.org/dist/$(VER_57)/node-$(VER_57)-headers.tar.gz | tar xz -C targets
	curl https://nodejs.org/dist/$(VER_59)/node-$(VER_59)-headers.tar.gz | tar xz -C targets
	curl https://nodejs.org/dist/$(VER_64)/node-$(VER_64)-headers.tar.gz | tar xz -C targets
	curl https://nodejs.org/dist/$(VER_67)/node-$(VER_67)-headers.tar.gz | tar xz -C targets
	curl https://nodejs.org/dist/$(VER_72)/node-$(VER_72)-headers.tar.gz | tar xz -C targets
	curl https://nodejs.org/dist/$(VER_79)/node-$(VER_79)-headers.tar.gz | tar xz -C targets
	
	# this is temporary support for Node 13.8 and lower (will be removed when more Node versions come)
	curl https://nodejs.org/dist/$(VER_79_8)/node-$(VER_79_8)-headers.tar.gz | tar xz -C targets
Linux:
	g++ $(CPP_SHARED) -static-libstdc++ -static-libgcc -I $$NODE/include/node -I $$NODE/src -I $$NODE/deps/uv/include -I $$NODE/deps/v8/include -I $$NODE/deps/openssl/openssl/include -I $$NODE/deps/zlib -s -o dist/bindings/cws_linux_$$ABI.node
Darwin:
	g++ $(CPP_SHARED) $(CPP_OSX) -I $$NODE/include/node -o dist/bindings/cws_darwin_$$ABI.node
