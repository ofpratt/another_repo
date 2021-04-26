- dashboard: test_dash_for_OP
  title: New Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Merge tile
    title: Merge tile
    merged_queries:
    - model: op_fresh_and_free_space
      explore: order_items
      type: table
      fields: [products.brand, products.category, products.count, products.price_count_dist]
      filters:
        products.brand: A%
        users.city: ''
      sorts: [products.count desc]
      limit: 500
      show_view_names: false
      show_row_numbers: true
      truncate_column_names: false
      hide_totals: false
      hide_row_totals: false
      table_theme: editable
      limit_displayed_rows: false
      enable_conditional_formatting: false
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      defaults_version: 1
      hidden_fields: []
      y_axes: []
    - model: op_fresh_and_free_space
      explore: order_items
      type: table
      fields: [orders.user_id, users.first_name, users.count, users.state, orders.count_distinct]
      sorts: [users.count desc]
      limit: 500
      join_fields:
      - field_name: users.first_name
        source_field_name: products.brand
      - field_name: users.state
        source_field_name: products.category
    color_application:
      collection_id: test-palette
      palette_id: test-palette-categorical-0
      options:
        steps: 5
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    series_types: {}
    point_style: none
    series_colors:
      users.count: "#C2DD67"
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    type: looker_bar
    row: 0
    col: 0
    width: 13
    height: 7
  - title: not merge
    name: not merge
    model: op_fresh_and_free_space
    explore: order_items
    type: looker_line
    fields: [products.brand, users.city, users.count]
    filters:
      products.brand: A%
      users.city: ''
    sorts: [users.count desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: []
    series_types: {}
    series_colors:
      users.count: "#B1399E"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen: {}
    row: 0
    col: 13
    width: 11
    height: 7
  - name: 'Test '
    type: text
    title_text: 'Test '
    subtitle_text: Trying to save text
    body_text: 'Let''s hope it works. Or maybe let''s hope it doesn''t so we can figure
      out how to fix it. '
    row: 7
    col: 0
    width: 8
    height: 6
