connection: "lookerdata_standard_sql"

include: "/views/flights/*.view.lkml"                # include all views in the views/ folder in this project

explore: flights_arr {
  label: "Test self join explore"
  from: flights
  join: flights_dep {
    from: flights
    sql_on: ${flights_arr.arrival_date} = ${flights_dep.departure_date} ;;
    relationship: one_to_one
    type: left_outer
  }
}




# }
