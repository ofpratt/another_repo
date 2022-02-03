 include: "/models/op_fresh_and_free_space.model.lkml"

  view: ndt_datatonic_test {
    derived_table: {
      explore_source: order_items {
        column: id { field: orders.id }
        column: created_date { field: orders.created_date }
        column: brand { field: products.brand }
        column: count { field: orders.count }
        derived_column: id_number {sql: ROW_NUMBER() OVER (ORDER BY created_date ASC) ;;}
      bind_filters: {
        from_field: common_filters.test_bug_filter
        to_field: products.brand
      }
      }

    }
    dimension: id {
      description: "this is the ID field"
      type: number
    }
    dimension: created_date {
      type: date
    }
    dimension: brand {}
    dimension: count {
      type: number
    }
    dimension: id_number {
      type: number
    }
  }
