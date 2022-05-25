data_dir  = "/opt/nomad"
bind_addr = "0.0.0.0" # the default

advertise {
  # Defaults to the first private IP address.
  http = "0.0.0.0"
  rpc  = "0.0.0.0"
  serf = "0.0.0.0:5648" # non-default ports may be specified
}

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = false
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

#consul {
#  address = "1.2.3.4:8500"
#}

ui {
  enabled =  true
}
