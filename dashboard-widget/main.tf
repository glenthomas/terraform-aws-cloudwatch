locals {
  position = var.position != null ? {
      x: var.position.x,
      y: var.position.y,
  } : {}
  size = var.size != null ? {
      width: var.size.width,
      height: var.size.height,
  } : {}
}

output widget {
    value = merge(
    {
      type: "metric",
      properties: {
          metrics: var.metrics,
          view: var.view,
          stacked: false,
          region: var.region,
          period: 60,
          setPeriodToTimeRange: var.set_period_to_time_range,
          title: var.title,
          yAxis: {
              left: {
                  min: 0,
                  showUnits: false,
                  label: "Count"
              }
          },
          legend: {
            position: var.legend_position
          },
          labels: {
            visible: var.show_labels
          }
      }
  },
  local.position,
  local.size
  )
}