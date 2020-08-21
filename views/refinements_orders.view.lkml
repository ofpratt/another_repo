# include: "/views/orders.view.lkml"
# view: +orders {
#
#   measure: filtered_count_complete {
#     type: count
#     filters: [status: "complete"]
#     sql: ${count} ;;
#   }
#
# }
