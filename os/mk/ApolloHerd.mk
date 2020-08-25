POLLOHERD_TAG=v1.1
${OPT_PATH}/ApolloHerd: ${OPT_PATH}/BUTool | ${OPT_PATH}
	cd ${OPT_PATH} && \
		git clone --recursive --branch master https://github.com/ammitra/ApolloHerd.git
	cp ${MODS_PATH}/build_ApolloHerd.sh ${OPT_PATH}/ApolloHerd/
	sudo chroot ${INSTALL_PATH} ${QEMU_PATH}/${QEMU} /bin/bash /opt/ApolloHerd/build_ApolloHerd.sh
