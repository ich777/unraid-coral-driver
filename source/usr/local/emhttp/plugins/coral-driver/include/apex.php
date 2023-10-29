<?php

class apex {
  public $name;
  public $index;
  public $path;
  public $temperature;
  public $status;
  public $temp;
  public $temp_hot;
  public $temp_hot_en;
  public $temp_hot2;
  public $temp_hot2_en;
  public $temp_tripp0;
  public $temp_tripp1;
  public $temp_tripp2;
  public $frequency;
  public $framework_version;
  public $driver_version;

  function __construct($name) {
    $this->name = $name;
	$this->index = intval(str_replace("apex_", "", $this->name)) + 1;
	$this->path = "/sys" . shell_exec("udevadm info --query=path --name=/dev/" . $this->name);
	$this->path = trim($this->path);
	$this->temperature = number_format(file_get_contents($this->path . "/temp") /1000, 2);
	$this->status = file_get_contents($this->path . "/status");
	if ($this->temperature <= -50) {
		$this->status = '<b style="color:red">' . trim($this->status);
	} else {
		$this->status = '<b style="color:green">' . trim($this->status);
	}
	if ($this->temperature <= -50) {
		$this->temp = '<b style="color:red">SHUTDOWN';
	} else {
		$this->temp = '<b style="color:green">' . $this->temperature . ' °C';
	}
	$this->temp_hot = number_format(file_get_contents($this->path . "/hw_temp_warn1") /1000, 2);
	$this->temp_hot_en = file_get_contents($this->path . "/hw_temp_warn1_en");
	$this->temp_hot2 = number_format(file_get_contents($this->path . "/hw_temp_warn2") /1000, 2);
	$this->temp_hot2_en = file_get_contents($this->path . "/hw_temp_warn2_en");
	$this->temp_tripp0 = number_format(file_get_contents($this->path . "/trip_point0_temp") /1000, 2);
	$this->temp_tripp1 = number_format(file_get_contents($this->path . "/trip_point1_temp") /1000, 2);
	$this->temp_tripp2 = number_format(file_get_contents($this->path . "/trip_point2_temp") /1000, 2);
	if ($this->temperature >= $this->temp_tripp2) {
		$this->frequency = '<b>62.5 MHz -</b><b style="color:red"> THROTTLED';
	} elseif ($this->temperature >= $this->temp_tripp1) {
		$this->frequency = '<b>125 MHz -</b><b style="color:#e74c3c"> THROTTLED';
	} elseif ($this->temperature >= $this->temp_tripp0) {
		$this->frequency = '<b>250 MHz -</b><b style="color:orange"> THROTTLED';
	} elseif ($this->temperature <= -50) {
		$this->frequency = '<b style="color:red">SHUTDOWN';
	} else {
		$this->frequency = '<b style="color:green">500 MHz';
	}
	$this->framework_version = file_get_contents($this->path . "/framework_version");
	$this->driver_version = file_get_contents($this->path . "/driver_version");
  }
  public function getJsonData() {
    return json_encode(['name' => $this->name, 'temp' => $this->temp, 'status' => $this->status]);
  }
}

if (isset($_POST['action']) && $_POST['action'] == 'updateValues') {
    $apexNames = json_decode($_POST['apexNames']);
    $data = [];
    foreach ($apexNames as $name) {
        $apexInstance = new Apex($name);
        $data[] = [
		    'name' => $apexInstance->name,
            'status' => $apexInstance->status,
            'temp' => $apexInstance->temp,
            'frequency' => $apexInstance->frequency
        ];
    }
    echo json_encode($data);
}
