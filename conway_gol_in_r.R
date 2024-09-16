# Conway's Game of Life in R with Shiny GUI

# Required libraries
library(shiny)
library(ggplot2)

# Grid parameters
grid_size <- 50
initialize_grid <- function(size) {
  matrix(sample(c(0, 1), size^2, replace = TRUE, prob = c(0.8, 0.2)), nrow = size)
}

# Game rules
count_neighbors <- function(grid) {
  n <- nrow(grid)
  m <- ncol(grid)
  
  neighbors <- matrix(0, n, m)
  
  for (i in 1:n) {
    for (j in 1:m) {
      for (di in -1:1) {
        for (dj in -1:1) {
          if (di != 0 || dj != 0) {
            ni <- (i + di - 1) %% n + 1
            nj <- (j + dj - 1) %% m + 1
            neighbors[i, j] <- neighbors[i, j] + grid[ni, nj]
          }
        }
      }
    }
  }
  
  return(neighbors)
}

update_grid <- function(grid) {
  neighbors <- count_neighbors(grid)
  grid <- ifelse(neighbors == 3 | (grid == 1 & neighbors == 2), 1, 0)
  return(grid)
}

# Visualization
grid_to_df <- function(grid) {
  data.frame(
    x = rep(1:ncol(grid), each = nrow(grid)),
    y = rep(nrow(grid):1, ncol(grid)),
    value = as.vector(grid)
  )
}

plot_grid <- function(grid) {
  df <- grid_to_df(grid)
  ggplot(df, aes(x, y, fill = factor(value))) +
    geom_tile() +
    scale_fill_manual(values = c("white", "black"), guide = "none") +
    theme_void() +
    coord_equal()
}

# Shiny UI
ui <- fluidPage(
  titlePanel("Conway's Game of Life"),
  
  sidebarLayout(
    sidebarPanel(
      actionButton("step_forward", "Step Forward"),
      actionButton("step_backward", "Step Backward"),
      actionButton("reset", "Reset Grid"),
      actionButton("clear", "Clear Grid"),  # New button
      hr(),
      helpText("Click on cells in the grid to toggle their state.")
    ),
    
    mainPanel(
      plotOutput("game_plot", click = "plot_click", height = "600px")
    )
  )
)

server <- function(input, output, session) {
  grid <- reactiveVal(initialize_grid(grid_size))
  history <- reactiveVal(list())
  is_running <- reactiveVal(FALSE)
  iteration <- reactiveVal(0)
  
  # Debug output
  output$debug_output <- renderPrint({
    paste("Is running:", is_running(), "\n",
          "Iteration:", iteration(), "\n",
          "Alive cells:", sum(grid()))
  })
  
  # Function to update the grid
  update_grid_once <- function() {
    current_grid <- grid()
    new_grid <- update_grid(current_grid)
    if (!identical(current_grid, new_grid)) {
      history(c(history(), list(current_grid)))
      grid(new_grid)
      iteration(iteration() + 1)
      print(paste("Grid updated. Iteration:", iteration(), "Alive cells:", sum(new_grid)))
    } else {
      print("Grid unchanged")
    }
  }
  
  output$game_plot <- renderPlot({
    grid_data <- grid()
    print("Plotting new grid state")  # Debugging line
    plot_grid(grid_data)
  })
  
  # Step Forward button
  observeEvent(input$step_forward, {
    update_grid_once()
  })
  
  # Step Backward button
  observeEvent(input$step_backward, {
    if (length(history()) > 0) {
      grid(history()[[length(history())]])
      history(history()[-length(history())])
    }
  })
  
  # Reset Grid button
  observeEvent(input$reset, {
    grid(initialize_grid(grid_size))
    history(list())
  })
  
  # Clear Grid button
  observeEvent(input$clear, {
    grid(matrix(0, nrow = grid_size, ncol = grid_size))
    history(list())
  })
  
  # Toggle cell state on click
  observeEvent(input$plot_click, {
    click_x <- as.integer(input$plot_click$x)
    click_y <- as.integer(grid_size - input$plot_click$y + 1)
    
    if (click_x >= 1 && click_x <= grid_size && click_y >= 1 && click_y <= grid_size) {
      new_grid <- grid()
      new_grid[click_y, click_x] <- 1 - new_grid[click_y, click_x]
      grid(new_grid)
    }
  })
}


# Run the Shiny app
shinyApp(ui = ui, server = server)