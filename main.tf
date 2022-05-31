resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "description" = "A user ID-based request.",
        "properties" = {
            "USER_ID" = {
                "description" = "The user ID.",
                "type" = "string"
            }
        },
        "required" = [
            "USER_ID"
        ],
        "title" = "UserIdRequest",
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "description" = "Returns a user\u2019s presence.",
        "properties" = {
            "presence" = {
                "description" = "The user\u2019s presence, which indicates whether the user can be reached.",
                "title" = "Presence",
                "type" = "string"
            }
        },
        "title" = "Get User Presence Response",
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/users/$${input.USER_ID}/presences/PURECLOUD"
        headers = {
            UserAgent = "PureCloudIntegrations/1.0"
            Content-Type = "application/x-www-form-urlencoded"
        }
    }

    config_response {
        success_template = "{\n   \"presence\": $${presence}\n}"
        translation_map = { 
            presence = "$.presenceDefinition.systemPresence"
        }
    }
}