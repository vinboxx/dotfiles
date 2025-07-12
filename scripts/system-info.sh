#!/bin/bash

# Function to colorize temperature based on heat level
colorize_temperature() {
  local temp="$1"
  local temp_type="${2:-cpu}"  # cpu or drive, defaults to cpu

  # Extract numeric value from temperature string
  local temp_num=$(echo "$temp" | grep -o '[0-9]\+' | head -1)

  # If no numeric value found, return as-is
  if [[ $temp_num == '' ]]; then
    echo "$temp"
    return
  fi

  # Define color codes
  local RESET='\033[0m'
  local GREEN='\033[32m'     # Cool - good temps
  local YELLOW='\033[33m'    # Warm - acceptable temps
  local ORANGE='\033[38;5;208m'  # Hot - concerning temps
  local RED='\033[31m'       # Very hot - dangerous temps
  local BOLD_RED='\033[1;31m'    # Critical - immediate attention

  # Set temperature thresholds based on component type
  local cool_max warm_max hot_max critical_max
  if [[ $temp_type == "drive" ]]; then
    # Drive temperature thresholds (typically lower than CPU)
    cool_max=35
    warm_max=45
    hot_max=55
    critical_max=65
  else
    # CPU temperature thresholds
    cool_max=50
    warm_max=70
    hot_max=85
    critical_max=95
  fi

  # Choose color based on temperature
  local color
  if [[ $temp_num -le $cool_max ]]; then
    color=$GREEN
  elif [[ $temp_num -le $warm_max ]]; then
    color=$YELLOW
  elif [[ $temp_num -le $hot_max ]]; then
    color=$ORANGE
  elif [[ $temp_num -le $critical_max ]]; then
    color=$RED
  else
    color=$BOLD_RED
  fi

  # Return colorized temperature
  echo -e "${color}${temp}${RESET}"
}

# Function to generate temperature output as a string (for buffered display)
generate_temperature_output() {
  local output=""

  # Header
  output+="========================================\n"
  output+="     System Temperature Monitor\n"
  output+="========================================\n\n"

  # Get and print all CPU core temperatures
  output+="=== CPU Temperature(s) ===\n"
  local core_temperatures=$(get_all_core_temperatures)
  if [[ $core_temperatures != '' ]]; then
    # Process each line and colorize temperatures
    while IFS= read -r line; do
      if [[ $line == *"temperature:"* ]]; then
        local temp_part=$(echo "$line" | awk -F'temperature: ' '{print $2}')
        local label_part=$(echo "$line" | awk -F'temperature: ' '{print $1}')
        local colored_temp=$(colorize_temperature "$temp_part" "cpu")
        output+="${label_part}temperature: ${colored_temp}\n"
      else
        output+="$line\n"
      fi
    done <<< "$core_temperatures"
  else
    output+="CPU temperature: N/A (sensors not available)\n"
  fi
  output+="\n"

  # Print SATA drive temperatures
  output+="=== SATA Drive Temperature(s) ===\n"
  local sata_found=false
  for drive in /dev/sd?; do
    if [ -e "$drive" ]; then
      local temperature=$(get_drive_temperature "$drive")
      local drive_name=$(get_drive_name "$drive")
      if [[ $temperature != '' ]]; then
        local colored_temp=$(colorize_temperature "$temperature°C" "drive")
        output+="$drive ($drive_name) temperature: ${colored_temp}\n"
      else
        output+="$drive ($drive_name) temperature: N/A\n"
      fi
      sata_found=true
    fi
  done
  if [[ $sata_found == false ]]; then
    output+="No SATA drives found\n"
  fi
  output+="\n"

  # Print NVMe drive temperatures
  output+="=== NVMe Drive Temperature(s) ===\n"
  local nvme_found=false
  for drive in /dev/nvme?n?; do
    if [ -e "$drive" ]; then
      local temperature=$(get_drive_temperature "$drive")
      local drive_name=$(get_drive_name "$drive")
      if [[ $temperature != '' ]]; then
        local colored_temp=$(colorize_temperature "$temperature°C" "drive")
        output+="$drive ($drive_name) temperature: ${colored_temp}\n"
      else
        output+="$drive ($drive_name) temperature: N/A\n"
      fi
      nvme_found=true
    fi
  done
  if [[ $nvme_found == false ]]; then
    output+="No NVMe drives found\n"
  fi

  output+="---\n"
  output+="Updated: $(date '+%Y-%m-%d %H:%M:%S')\n"
  output+="Press Ctrl+C to stop monitoring\n\n"

  echo -e "$output"
}

# Function to display temperatures once (for single run mode)
display_temperatures() {
  # Get and print all CPU core temperatures
  echo "=== CPU Temperature(s) ==="
  core_temperatures=$(get_all_core_temperatures)
  if [[ $core_temperatures != '' ]]; then
    # Process each line and colorize temperatures
    while IFS= read -r line; do
      if [[ $line == *"temperature:"* ]]; then
        local temp_part=$(echo "$line" | awk -F'temperature: ' '{print $2}')
        local label_part=$(echo "$line" | awk -F'temperature: ' '{print $1}')
        local colored_temp=$(colorize_temperature "$temp_part" "cpu")
        echo -e "${label_part}temperature: ${colored_temp}"
      else
        echo "$line"
      fi
    done <<< "$core_temperatures"
  else
    echo "CPU temperature: N/A (sensors not available)"
  fi
  echo

  # Print SATA drive temperatures
  echo "=== SATA Drive Temperature(s) ==="
  sata_found=false
  for drive in /dev/sd?; do
    if [ -e "$drive" ]; then
      temperature=$(get_drive_temperature "$drive")
      drive_name=$(get_drive_name "$drive")
      if [[ $temperature != '' ]]; then
        colored_temp=$(colorize_temperature "$temperature°C" "drive")
        echo -e "$drive ($drive_name) temperature: ${colored_temp}"
      else
        echo "$drive ($drive_name) temperature: N/A"
      fi
      sata_found=true
    fi
  done
  if [[ $sata_found == false ]]; then
    echo "No SATA drives found"
  fi
  echo

  # Print NVMe drive temperatures
  echo "=== NVMe Drive Temperature(s) ==="
  nvme_found=false
  for drive in /dev/nvme?n?; do
    if [ -e "$drive" ]; then
      temperature=$(get_drive_temperature "$drive")
      drive_name=$(get_drive_name "$drive")
      if [[ $temperature != '' ]]; then
        colored_temp=$(colorize_temperature "$temperature°C" "drive")
        echo -e "$drive ($drive_name) temperature: ${colored_temp}"
      else
        echo "$drive ($drive_name) temperature: N/A"
      fi
      nvme_found=true
    fi
  done
  if [[ $nvme_found == false ]]; then
    echo "No NVMe drives found"
  fi

  echo "---"
  echo "Updated: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "Press Ctrl+C to stop monitoring"
  echo
}

# Function to get drive model/name
get_drive_name() {
  local drive="$1"
  local info="$(sudo smartctl -i "$drive" 2>/dev/null)"
  local drive_name=""

  # Try different patterns to get drive name
  # Method 1: Device Model (most common)
  drive_name=$(echo "$info" | grep -i 'Device Model:' | awk -F': ' '{print $2}' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

  # Method 2: Model Number (for some drives)
  if [[ $drive_name == '' ]]; then
    drive_name=$(echo "$info" | grep -i 'Model Number:' | awk -F': ' '{print $2}' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
  fi

  # Method 3: Product (for some drives)
  if [[ $drive_name == '' ]]; then
    drive_name=$(echo "$info" | grep -i 'Product:' | awk -F': ' '{print $2}' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
  fi

  # Method 4: Model Family (fallback)
  if [[ $drive_name == '' ]]; then
    drive_name=$(echo "$info" | grep -i 'Model Family:' | awk -F': ' '{print $2}' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
  fi

  # If still no name found, try to get it from a different pattern
  if [[ $drive_name == '' ]]; then
    drive_name=$(echo "$info" | grep -E '^(Device|Model|Product)' | head -1 | awk -F': ' '{print $2}' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
  fi

  # Return the drive name or "Unknown" if not found
  if [[ $drive_name != '' ]]; then
    echo "$drive_name"
  else
    echo "Unknown Drive"
  fi
}

# Function to check if a drive exists and retrieve its temperature
get_drive_temperature() {
  local drive="$1"
  local info="$(sudo smartctl -a $drive)"
  local temp=""

  # Try different temperature patterns for various drive types
  # Traditional SATA drives
  temp=$(echo "$info" | grep '194 Temp' | awk '{print $10}')
  if [[ $temp == '' ]]; then
    temp=$(echo "$info" | grep '190 Airflow' | awk '{print $10}')
  fi

  # NVMe drives - common patterns
  if [[ $temp == '' ]]; then
    temp=$(echo "$info" | grep 'Temperature:' | head -1 | awk '{print $2}' | sed 's/°C//')
  fi
  if [[ $temp == '' ]]; then
    temp=$(echo "$info" | grep 'Temperature Sensor 1:' | awk '{print $4}')
  fi
  if [[ $temp == '' ]]; then
    temp=$(echo "$info" | grep 'Current Drive Temperature:' | awk '{print $4}')
  fi

  # Additional NVMe patterns
  if [[ $temp == '' ]]; then
    temp=$(echo "$info" | grep 'Composite Temperature:' | awk '{print $3}')
  fi
  if [[ $temp == '' ]]; then
    temp=$(echo "$info" | grep -i 'temperature' | head -1 | grep -o '[0-9]\+' | head -1)
  fi

  echo "$temp"
}

# Function to retrieve all CPU core temperatures
get_all_core_temperatures() {
  local output=""
  local found_temps=false

  # Try different methods to get CPU temperature
  # Method 1: lm-sensors (if available) - get all cores
  if command -v sensors >/dev/null 2>&1; then
    local sensor_output=$(sensors 2>/dev/null | grep 'Core [0-9]:')
    if [[ $sensor_output != '' ]]; then
      while IFS= read -r line; do
        local core_num=$(echo "$line" | awk '{print $1 $2}' | sed 's/://g')
        local temp=$(echo "$line" | awk '{print $3}')
        output+="CPU $core_num temperature: $temp\n"
        found_temps=true
      done <<< "$sensor_output"
    fi
  fi

  # Method 2: Try thermal zone files (Linux) - check multiple zones
  if [[ $found_temps == false ]]; then
    for zone in /sys/class/thermal/thermal_zone*/temp; do
      if [[ -f "$zone" ]]; then
        local zone_num=$(echo "$zone" | grep -o 'thermal_zone[0-9]*' | grep -o '[0-9]*')
        local temp_millidegrees=$(cat "$zone" 2>/dev/null)
        if [[ $temp_millidegrees != '' ]] && [[ $temp_millidegrees -gt 10000 ]]; then
          local temp_celsius=$((temp_millidegrees / 1000))
          output+="Thermal Zone $zone_num temperature: ${temp_celsius}°C\n"
          found_temps=true
        fi
      fi
    done
  fi

  # Method 3: Try hwmon files (Linux) - look for CPU cores
  if [[ $found_temps == false ]]; then
    for hwmon_dir in /sys/class/hwmon/hwmon*; do
      if [[ -d "$hwmon_dir" ]]; then
        local name_file="$hwmon_dir/name"
        if [[ -f "$name_file" ]]; then
          local hwmon_name=$(cat "$name_file" 2>/dev/null)
          # Look for CPU-related hwmon devices
          if [[ $hwmon_name == *"coretemp"* ]] || [[ $hwmon_name == *"k10temp"* ]] || [[ $hwmon_name == *"cpu"* ]]; then
            for temp_file in "$hwmon_dir"/temp*_input; do
              if [[ -f "$temp_file" ]]; then
                local temp_millidegrees=$(cat "$temp_file" 2>/dev/null)
                if [[ $temp_millidegrees != '' ]] && [[ $temp_millidegrees -gt 10000 ]]; then
                  local temp_celsius=$((temp_millidegrees / 1000))
                  local temp_label=$(basename "$temp_file" | sed 's/_input//')
                  output+="CPU $temp_label temperature: ${temp_celsius}°C\n"
                  found_temps=true
                fi
              fi
            done
          fi
        fi
      fi
    done
  fi

  # Method 4: macOS temperature (if on macOS)
  if [[ $found_temps == false ]] && [[ "$(uname)" == "Darwin" ]]; then
    if command -v powermetrics >/dev/null 2>&1; then
      local mac_temp=$(sudo powermetrics --samplers smc -n 1 -i 1 2>/dev/null | grep "CPU die temperature" | awk '{print $4$5}')
      if [[ $mac_temp != '' ]]; then
        output+="CPU die temperature: $mac_temp\n"
        found_temps=true
      fi
    fi
  fi

  # Return the output (remove trailing newline)
  echo -e "${output%\\n}"
}

# Trap Ctrl+C to exit gracefully
trap 'echo -e "\n\nMonitoring stopped."; exit 0' SIGINT

# Check if refresh mode is requested
if [[ "$1" == "--refresh" ]] || [[ "$1" == "-r" ]]; then
  echo "Starting temperature monitoring (refreshing every 3 seconds)..."
  echo "Press Ctrl+C to stop"
  echo

  while true; do
    # Generate all output at once, then display it instantly
    full_output=$(generate_temperature_output)

    # Move to top and display all content at once
    printf '\033[H\033[2J'  # Clear screen and move to top
    echo "$full_output"

    # Wait 3 seconds before next update
    sleep 3
  done
else
  # Single run mode (original behavior)
  display_temperatures
  echo
  echo "Tip: Use './system-info.sh --refresh' or './system-info.sh -r' for continuous monitoring"
fi
