variable "title" {
    type = string
    description = "The title text to be displayed by the widget."
}

variable "metrics" {
    type = any
}

variable "region" {
    type = string
}

variable "position" {
    type = object({
        x = number,
        y = number
    })
    default = null
}

variable "size" {
    type = object({
        width = number,
        height = number
    })
    default = null
}

variable "view" {
    type = string
    default = "timeSeries"
    description = "Specifies how the query results are displayed. Specify table to view the results as a table. Specify timeSeries to display this metric as a line graph. Specify bar to display it as a bar graph. Specify pie to display it as a pie graph."
}

variable "set_period_to_time_range" {
    type = bool
    default = false
}

variable "legend_position" {
    type = string
    default = "bottom"
    description = "bottom/right/hidden"
}

variable "show_labels" {
    type = bool
    default = true
}
