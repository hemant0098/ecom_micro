
package com.ecommerce.authservice.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Getter
@Setter
@Configuration
@ConfigurationProperties(prefix = "keycloak.sso")
public class SsoProperties {

    /**
     * Public APISIX URL where Keycloak redirects after login.
     */
    private String backendCallbackUrl =
            "http://3.24.124.211:30006/api/v1/auth/callback";

    /**
     * Frontend callback URLs allowed after successful login.
     */
    private List<String> allowedRedirectUris = List.of(
            "http://3.24.124.211:3001/auth/callback",
            "http://3.24.124.211:3000/auth/callback",
            "http://localhost:3000/auth/callback",
            "http://localhost:3001/auth/callback"
    );

    /**
     * Default frontend callback URL.
     */
    private String defaultFrontendRedirect =
            "http://3.24.124.211:3001/auth/callback";

    /**
     * OIDC scopes.
     */
    private String scope = "openid profile email";

    /**
     * Login state expiration in seconds.
     */
    private long stateTtlSeconds = 300;

    /**
     * Single-use ticket expiration in seconds.
     */
    private long ticketTtlSeconds = 60;
}
