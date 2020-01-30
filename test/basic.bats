load helpers

function setup() {
    setup_crio
}

function teardown() {
    cleanup_crio
}

@test "basic cri-o workings" {
    crictl runp test/basic-pod-config.json
    # crictl pull busybox
    # crictl images
    podid=$(crictl pods | grep nginx-sandbox | awk '{ print $1 }')
    echo "========== creating" >&3
    ctrid=$(crictl create $podid test/basic-container-config.json test/basic-pod-config.json)
    echo "========== starting ctr id $ctrid" >&3
    echo "before : crictl start ctr $ctrid"
    crictl start $ctrid
    echo "after: crictl start ctr $ctrid"
    echo "========== started ctr" >&3
    
    echo "################################################################################"
    crictl ps -a | grep busybox
    echo "################################################################################"
    crictl stop $ctrid
    crictl stopp $podid
    crictl rmp $podid
}
