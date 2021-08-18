# include: "/views/orders.view.lkml"
# view: extended_orders {
# extends: [orders]
#
# measure: filtered_count {
#   type: count
#   filters: [status: "complete"]
#   sql: ${count} ;;
# }
# }
