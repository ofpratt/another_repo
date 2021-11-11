connection: "ilaka_postgres"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project


explore: json_data {}

explore: liquid_lunch {}

explore: just_dates {}

explore: mock_data {}

explore: order_items {}
