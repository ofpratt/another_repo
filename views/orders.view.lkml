view: orders {
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]

  dimension: id {
    description: "this is the ID field"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  #######Test Comment

  parameter: date_selector{
    type:  date
  }

dimension: is_before {
  type: yesno
  sql: ${created_date} < {% parameter date_selector %} ;;
}

parameter: filter_bug_test {
    type: string
    allowed_value: {value: "(All)"}
    allowed_value: {value: "Access Group"}

}



  dimension: media_url {
    label: "Post Image"
    description: "No preview available for Media Type 'VIDEO'"
    sql: 1=1 ;;
    html: <img src="https://www.thesprucepets.com/thmb/3-ISVJpCrp9TUfeRdH1mfzJlHGg=/960x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/golden-retriever-puppy-in-grass-923135452-5c887d4146e0fb00013365ba.jpg" height="20px"/> ;;
  }

  dimension: media_url_large {
    hidden: no
    label: "Post Image Large"
    description: "No preview available for Media Type 'VIDEO'"
    sql: 1=1 ;;
    html: <img src="https://www.thesprucepets.com/thmb/3-ISVJpCrp9TUfeRdH1mfzJlHGg=/960x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/golden-retriever-puppy-in-grass-923135452-5c887d4146e0fb00013365ba.jpg" height="125px" width="125px"/> ;;
  }




dimension: goes_with_filter_bug_test {
  type:  string
  sql:
   {% if filter_bug_test._parameter_value == "''" %}                                          NULl
        {% elsif filter_bug_test._parameter_value == "'(All)'" %}                               ${all_values}
        {% elsif filter_bug_test._parameter_value == "'Access Group'" %}                         ${status_dim}
        {% endif %};;
}

  dimension: all_values {
    label: "A sum of all group values"
    type: string
    sql: 'all' ;;
    }

    parameter: string_filter_boi {
      type: string
      suggest_explore: order_items
      suggest_dimension: products.brand
    }


parameter: number_of_days_test {
  type: number
}

filter: date_selector_test {
  type: date
  sql: ${created_date} >= date_add({% date_start date_selector_test %}, interval -{% parameter number_of_days_test %} day)
  AND
  ${created_date} <= date_add({% date_start date_selector_test %}, interval {% parameter number_of_days_test %} day) ;;
}

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week
    ]
    sql: ${TABLE}.created_at  ;;
  }

  filter: dumb_date_filter {
    type: date
    sql: {% condition %} ${created_date} {% endcondition %} ;;
  }

  dimension: seven_days {
    type: date
    sql: date_add({% date_start dumb_date_filter %}, interval -7 day) ;;
  }
  parameter: date_label {
    type: number
    default_value: "{{ orders.seven_days }}"
  }

dimension: dumb_date_dimension {
  #label: "Compared to 7th Day Prior {{ orders.seven_days._value }}"
  label: "{% parameter date_label %}"
  sql: 1 ;;
}

dimension: created_date_no_nulls{
  type: date
  sql: case when ${created_date} = "2019-12-22" then 0 else ${created_date} end;;
}

dimension: test_coalesce {
  type: number
  sql: coalesce(0,${created_date_no_nulls}) ;;
}
  parameter: date_bucket {
    type: string
    default_value: "Month"
    allowed_value: { value: "Month" }
    allowed_value: { value: "Quarter" }
    allowed_value: { value: "Year" }
  }

  dimension: opportunity_close_bucket {
    label_from_parameter: date_bucket
    sql:
    {% if date_bucket._parameter_value == "'Month'" %}
    cast(${created_month} as string)
    {% elsif date_bucket._parameter_value == "'Quarter'" %}
    cast(${created_quarter} as string)
    {% elsif date_bucket._parameter_value == "'Year'" %}
    cast(${created_year} as string)

    {% endif %};;
    html: {% if date_bucket._parameter_value == "'Month'" %}
      {{ opportunity_close_month._rendered_value | date: "%b %y" }}
      {% elsif date_bucket._parameter_value == "'Quarter'" %}
      {{ opportunity_close_quarter._rendered_value }}
      {% endif %};;
  }

  dimension: status_dim {
    hidden: no
    type: string
    description: "This shows what stage an order is in"
    sql: ${TABLE}.status ;;
  }

  dimension: yes_no_status {
    type: yesno
    sql: ${status_dim} = "pending" ;;
  }

  measure: sum_of_cancelled{
    type: sum
    sql: ${id};;
    filters: [status_dim: "cancelled"]
  }

  measure: count_of_cancelled {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status_dim: "cancelled"]
  }

  measure: addition_of_cancelled{
    type: number
    sql: ${sum_of_cancelled} + ${count_of_cancelled} ;;
    link: {
      label: "Test Drill"
      url: "/explore/op_fresh_and_free_space/orders?fields=orders.id&f[orders.yes_no_status]=yes&sorts=orders.id&"

    }
  }

#   filter: status {
#     type: string
#     description: "this is a status"
#     #suggest_dimension: status_dim
#     sql: {% condition status %} ${status_dim} {% endcondition %};;
#   }

filter: test_user_id {
  type: number
  sql: {% condition %}${user_id}{% endcondition %} ;;
}


  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
    link: {
      label: "SME Lookml Dashboard Link"
      url: "/dashboards/1133?Created+Date={{ _filters['orders.created_date'] }}&ID={{ value | url_encode }}&Name+to+Num+ID={{ orders.name_to_num_id._value }}"
      }
      link: {
        label: "SME LookML Explore Link"
        url: "/explore/op_fresh_and_free_space/orders?fields=orders.id,orders.user_id,orders.status_dim&f[orders.status_dim]=&f[orders.user_id]={{ value }}&f[orders.created_date]={{ _filters['orders.created_date'] }}"
      }
      link: {
        label: "Test Drill"
        url: "/explore/op_fresh_and_free_space/orders?fields=orders.id,orders.user_id={{ value }}
        &{% if orders.created_date._value == null %}f[orders.created_date]= null{% else %}f[orders.created_date]={{ orders.created_date._value }}{% endif %}"
      }

    link: {
      label: "Test Drill without null"
      url: "/explore/op_fresh_and_free_space/orders?fields=orders.id,orders.user_id={{ value }}&f[orders.created_date]={{ orders.created_date._value }}"
    }



  }

  measure: count_distinct {
    type: count_distinct
    sql: ${user_id} ;;
    html: <a href="{{ link }}&sorts=orders.created_date+desc">{{value}}</a> ;;
  }

  dimension: name_to_num_id {
    type: number
    sql: case when
    ${user_id} < 100 then 20
    when ${user_id} < 200 then 30
    when ${user_id} < 300 then 40
    else null
    end
    ;;
  }

  measure:  null_sum{
    type: sum
    sql: ${name_to_num_id}) ;;
  }

measure: has_value {
  type: number
  sql: max(${name_to_num_id} not null) ;;
}

measure: null_workaround{
  type: number
  sql: ${null_sum}/ nullif(${has_value}, 0) ;;
}

  parameter: name_to_num_filter {
    type: unquoted
    allowed_value: {
      label: "{{ _localization['apples'] }}"
      value: "1"
    }
    allowed_value: {
      label: "pears"
      value: "2"
    }
    allowed_value: {
      label: "banana"
      value: "3"
    }
  }

  #ughhhhhhh

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
    # link: {
    #   label: "This is another drill"
    #   url: "/explore/op_fresh_and_free_space/order_items?qid=AEvUVirUn64drymbj11cXg"
    # }
    link: {
      label: "Test Drill"
      url: "/explore/op_fresh_and_free_space/orders?fields=orders.id,orders.user_id={{ value }}&f[orders.created_date]={{ orders.created_date._value }}"
    }

  }
}
