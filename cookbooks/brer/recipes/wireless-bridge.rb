include_recipe "network_interfaces"

network_interfaces "wlan0" do
  target "172.16.27.1"
  mask "255.255.255.0"
  bridge [ "none" ]
end
