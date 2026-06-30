# ============================================================
# Alpha-Beta calibration with L_z and L_h calculations
# CSV output only
# ============================================================

setwd("/Calibration/Robustness and Sensitivity")

# Load required libraries
library(dplyr)

# Define parameters
g_target <- 0.017
sigma_k_target <- 37.4 / (100 - 37.4)  # Approximately 0.597444
theta <- 2
r <- 0.077
rho <- r - (g_target * theta)  # 0.077 - 0.034 = 0.043
delta_base <- 0.05
delta_shock <- 0.05 * 1.5  # 50% increase: 0.075

# Labor share base (from sigma_k_target)
labor_share_base <- 1 / (1 + sigma_k_target)  # Approximately 0.62599

# Define functions from the code
g_hat_fn <- function(b_l, b_k, alpha, theta, rho, delta) {
  denom <- theta - ((1 - 2*alpha) / (1 - alpha)) + 1
  num <- b_l - delta * (b_l / b_k) - (alpha / (1 - alpha)) * rho
  ((1 - alpha) / alpha) * (num / denom)
}

sigma_k_hat_fn <- function(b_l, b_k, alpha, beta, theta, rho, g, delta) {
  term1 <- (b_l / b_k)
  term2 <- ((1 - alpha) / (1 - beta))
  term3 <- ((g * (theta - 1) + rho + delta) / (g * (theta - ((1 - 2*alpha) / (1 - alpha))) + rho))
  term1 * term2 * term3
}

# Create a grid of alpha and beta values
alpha_seq <- seq(0.1, 0.9, by = 0.05)
beta_seq <- seq(0.1, 0.9, by = 0.05)
grid <- expand.grid(alpha = alpha_seq, beta = beta_seq)

# Initialize results data frame with additional columns for L_z and L_h
results <- data.frame(
  alpha = grid$alpha,
  beta = grid$beta,
  b_l = NA,
  b_k = NA,
  growth_change = NA,
  labor_share_change = NA,
  L_z_base = NA,
  L_h_base = NA,
  L_z_shock = NA,
  L_h_shock = NA
)

# Loop over each combination of alpha and beta
for (i in 1:nrow(results)) {
  alpha <- results$alpha[i]
  beta <- results$beta[i]
  
  # Skip if alpha or beta are at boundaries
  if (alpha < 0.2 || alpha > 0.85 || beta < 0.2 || beta > 0.85) {
    next
  }
  
  # Compute A and B for sigma_k equation
  A <- g_target * (theta - 1) + rho + delta_base
  B <- g_target * (theta - ((1 - 2*alpha) / (1 - alpha))) + rho
  
  # Compute R = b_l / b_k
  R <- sigma_k_target * (1 - beta) / (1 - alpha) * (B / A)
  
  # Compute D and C for g equation
  D <- theta - ((1 - 2*alpha) / (1 - alpha)) + 1
  C <- (alpha * g_target * D) / (1 - alpha) + (alpha / (1 - alpha)) * rho
  
  # Compute b_l and b_k
  b_l <- C + delta_base * R
  b_k <- b_l / R
  
  # Skip if b_l or b_k are not positive
  if (is.na(b_l) || is.na(b_k) || b_l <= 0 || b_k <= 0) {
    next
  }
  
  # Store b_l and b_k
  results$b_l[i] <- b_l
  results$b_k[i] <- b_k
  
  # Compute base L_z and L_h
  results$L_z_base[i] <- delta_base / b_k
  results$L_h_base[i] <- g_target * (alpha / (b_l * (1 - alpha)))
  
  # Compute new growth after shock
  g_new <- g_hat_fn(b_l, b_k, alpha, theta, rho, delta_shock)
  if (is.na(g_new)) {
    next
  }
  
  # Compute new sigma_k after shock
  sigma_k_new <- sigma_k_hat_fn(b_l, b_k, alpha, beta, theta, rho, g_new, delta_shock)
  if (is.na(sigma_k_new)) {
    next
  }
  
  # Compute new labor share
  labor_share_new <- 1 / (1 + sigma_k_new)
  
  # Compute changes in percentage points
  results$growth_change[i] <- (g_new - g_target) * 100
  results$labor_share_change[i] <- (labor_share_new - labor_share_base) * 100
  
  # Compute shock L_z and L_h
  results$L_z_shock[i] <- delta_shock / b_k
  results$L_h_shock[i] <- g_new * (alpha / (b_l * (1 - alpha)))
}

# Remove rows with NA values
valid_results <- results %>% filter(
  !is.na(b_l), 
  !is.na(growth_change), 
  !is.na(labor_share_change),
  !is.na(L_z_base),
  !is.na(L_h_base)
)

# Export L_z and L_h results (baseline and after shock)
L_data <- valid_results %>%
  select(alpha, beta, L_z_base, L_h_base, L_z_shock, L_h_shock)

write.csv(L_data, "L_z_L_h_values.csv", row.names = FALSE)
cat("L_z and L_h values exported to: L_z_L_h_values.csv\n")

# Export growth and labor share changes
growth_labor_data <- valid_results %>%
  select(alpha, beta, growth_change, labor_share_change)

write.csv(growth_labor_data, "alpha_beta.csv", row.names = FALSE)
cat("Growth and labor share changes exported to: alpha_beta.csv\n")

# Export the b_l and b_k values
b_values <- valid_results %>%
  select(alpha, beta, b_l, b_k)

write.csv(b_values, "b_l_b_k_values.csv", row.names = FALSE)
cat("b_l and b_k values exported to: b_l_b_k_values.csv\n")