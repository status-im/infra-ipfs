/* WORKSPACES ---------------------------------------------*/
/**
 * This is a hacky way of binding specific variable
 * values to different Terraform workspaces.
 *
 * Details:
 * https://github.com/hashicorp/terraform/issues/15966
 */

locals {
  env = {
    defaults = {
      hosts_count = 2
    }

    # For testing infra changes before rollout to other fleets
    test = {}
  }
}
/*---------------------------------------------------------*/
