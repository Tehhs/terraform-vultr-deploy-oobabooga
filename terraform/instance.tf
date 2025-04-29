resource "vultr_instance" "my_instance" {
    label = "sample-server"
    plan = "vc2-1c-1gb"
    region = "sgp"
    os_id = "2284"
    enable_ipv6 = true
}