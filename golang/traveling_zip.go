package main

import (
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

const (
	// Each Nest has this many Zips
	NUM_ZIPS = 10

	// Each Zip can carry between 1 and this many packages per flight
	// Note: a Zip can deliver more than 1 package per stop
	MAX_PACKAGES_PER_ZIP = 3

	// Zips fly a constant groundspeed (m/s)
	ZIP_SPEED_MPS = 30

	// Zips can fly a total roundtrip distance (m)
	ZIP_MAX_CUMULATIVE_RANGE_M = 160 * 1000 // 160 km -> meters

	SECONDS_PER_DAY = 24 * 60 * 60

	// Two acceptable priorities
	EMERGENCY = "Emergency"
	RESUPPLY  = "Resupply"
)

// You shouldn't need to modify this
type Hospital struct {
	name   string
	northM int
	eastM  int
}

// You shouldn't need to modify this
type Order struct {
	time         int
	hospitalName string
	priority     string
}

// You may need to modify this
type Flight struct {
	launchTime int
	orders     []Order
}

func (flight Flight) String() string {
	hospitalNames := []string{}
	for _, order := range flight.orders {
		hospitalNames = append(hospitalNames, order.hospitalName)
	}
	hospitalNamesStr := strings.Join(hospitalNames, "->")
	return fmt.Sprintf("<Flight %d to %s>", flight.launchTime, hospitalNamesStr)
}

// open a csv and return a slice of slices
func LoadCSV(csvPath string) [][]string {
	file, err := os.Open(csvPath)
	if err != nil {
		log.Fatal("Could not open file", err)
	}
	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		log.Fatal("Could not read file", err)
	}
	return records
}

// A function to read the input file and parse the CSV in to a
// map of hospital names to hospitals
func LoadHospitals(hospitalsPath string) map[string]Hospital {

	hospitals := map[string]Hospital{}
	records := LoadCSV(hospitalsPath)

	for _, record := range records {
		name := strings.TrimSpace(record[0])
		northM, err := strconv.Atoi(strings.TrimSpace(record[1]))
		if err != nil {
			log.Fatal(err)
		}
		eastM, err := strconv.Atoi(strings.TrimSpace(record[2]))
		if err != nil {
			log.Fatal(err)
		}
		hospital := Hospital{name, northM, eastM}
		hospitals[name] = hospital
	}

	return hospitals
}

// A function to read the input file and parse the CSV in to a slice of Orders
func LoadOrders(ordersPath string) []Order {

	orders := []Order{}
	records := LoadCSV(ordersPath)

	for _, record := range records {
		time, err := strconv.Atoi(strings.TrimSpace(record[0]))
		if err != nil {
			log.Fatal(err)
		}
		hospitalName := strings.TrimSpace(record[1])
		priority := strings.TrimSpace(record[2])
		order := Order{time, hospitalName, priority}
		orders = append(orders, order)
	}
	return orders
}

// a structure representing the data a zip scheduler may store. Feel free to
// modify this as you see fit.
type ZipScheduler struct {
	hospitals              map[string]Hospital
	numZips                int
	maxPackagesPerZip      int
	zipSpeedMps            int
	zipMaxCumulativeRangeM int
}

// A constructor for a ZipScheduler
func NewZipScheduler(
	hospitals map[string]Hospital,
	numZips int,
	maxPackagesPerZip int,
	zipSpeedMps int,
	zipMaxCumulativeRangeM int,
) ZipScheduler {
	zipScheduler := ZipScheduler{
		hospitals,
		numZips,
		maxPackagesPerZip,
		zipSpeedMps,
		zipMaxCumulativeRangeM,
	}
	return zipScheduler
}

/*
 * Used to add a new order to our queue
 * Called every time an order arrives (at most once per minute)
 */
func (zipScheduler ZipScheduler) QueueOrder(order Order) {
	// TODO: Implement this function
}

/*
 * Will be called periodically (approximately every 1 minute)
 * returns a list of hospitals to serve on the next flight. An empty slice
 * means to schedule no flights.
 */
func (zipScheduler ZipScheduler) LaunchFlights(
	currentTime int,
) []Flight {
	// TODO: Implement this function
	return []Flight{}
}

// The state for running through the orders and calling the scheduler.
// You may modify this as you see fit.
type Runner struct {
	orders       []Order
	hospitals    map[string]Hospital
	zipScheduler ZipScheduler
}

func NewRunner(
	orders []Order,
	hospitals map[string]Hospital,
	zipScheduler ZipScheduler,
) Runner {
	runner := Runner{orders, hospitals, zipScheduler}
	return runner
}

// Encapsulate logic to ask the scheduler to queue orders.
// Using a pointer here since we modify the orders belonging to the runner
func (runner *Runner) QueuePendingOrders(secSinceMidnight int) {
	for len(runner.orders) > 0 && runner.orders[0].time == secSinceMidnight {
		order := runner.orders[0]
		runner.orders = runner.orders[1:]
		fmt.Printf(
			"[%d] %s order received to %s\n",
			order.time,
			order.priority,
			order.hospitalName,
		)
		runner.zipScheduler.QueueOrder(order)
	}
}

// Calls launch flights on the scheduler and prints the outputs
func (runner Runner) UpdateLaunchFlights(secSinceMidnight int) {
	flights := runner.zipScheduler.LaunchFlights(secSinceMidnight)
	if len(flights) > 0 {
		fmt.Printf("[%d] Scheduling flights:\n", secSinceMidnight)
		for _, flight := range flights {
			fmt.Println(flight)
		}
	} else {
		fmt.Printf("[%d] Scheduling no flights\n", secSinceMidnight)
	}
}

// The entrypoint for the runner. This function will iterate through the day,
// dispatch orders, and request a flight schedule. You may modify this function
func (runner Runner) Run() {
	for secSinceMidnight := runner.orders[0].time; secSinceMidnight < SECONDS_PER_DAY; secSinceMidnight++ {
		runner.QueuePendingOrders(secSinceMidnight)
		if secSinceMidnight%60 == 0 {
			runner.UpdateLaunchFlights(secSinceMidnight)
		}
	}
}

/*
 * Usage:
 * go run traveling_zip.go
 * Runs the provided CSVs
 * Feel free to edit the main function
 */
func main() {
	// get input files
	workingDirectory, err := os.Getwd()
	if err != nil {
		fmt.Println(err)
		return
	}
	rootDir := filepath.Dir(workingDirectory)
	hospitalsPath := filepath.Join(rootDir, "inputs", "hospitals.csv")
	ordersPath := filepath.Join(rootDir, "inputs", "orders.csv")

	// load hospitals and orders data
	hospitals := LoadHospitals(hospitalsPath)
	orders := LoadOrders(ordersPath)

	// initialize scheduler
	zipScheduler := NewZipScheduler(
		hospitals,
		NUM_ZIPS,
		MAX_PACKAGES_PER_ZIP,
		ZIP_SPEED_MPS,
		ZIP_MAX_CUMULATIVE_RANGE_M,
	)

	// run the runner with orders and hospitals
	runner := Runner{orders, hospitals, zipScheduler}
	runner.Run()
}
