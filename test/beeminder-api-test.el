;; API Tests

;; beeminder-user-info

(ert-deftest beeminder-api-test/beeminder-user-info-returns-alist ()
  (let ((beeminder-auth-token "ABCDEF"))
    (with-mock
     (mock-get "users/test_user.json" "users-test_user.json")
     (let ((info (beeminder-user-info "test_user")))
       (should (listp info))
       (should (string= "test_user" (assoc-default 'username info)))))))


;; beeminder-me

(ert-deftest beeminder-api-test/beeminder-me-returns-alist ()
  (let ((beeminder-auth-token "ABCDEF"))
    (with-mock
     (mock-get "users/me.json" "users-test_user.json")
     (let ((info (beeminder-me)))
       (should (listp info))
       (should (string= "test_user" (assoc-default 'username info)))))))

(ert-deftest beeminder-api-test/beeminder-me-returns-error-when-no-auth-token ()
  (let ((beeminder-auth-token ""))
    (with-mock
     (mock-invalid-get "users/me.json" "incorrect_token.json")
     (let ((info (beeminder-me)))
       (should (listp info))
       (should (string= "no_token" (assoc-default 'token (assoc-default 'errors info))))))))

;; goals

(ert-deftest beeminder-api-test/fetch-goals-uses-global-when-no-override ()
  (let ((beeminder-username "GLOBAL-USERNAME")
        (beeminder-auth-token "ABCDEF"))
    (with-mock
     (mock-expected-get "users/GLOBAL-USERNAME/goals.json")
     (beeminder-fetch-goals))))


;; Internal Helper Tests

(ert-deftest beeminder-api-test/can-create-endpoint-without-query-vars ()
  (should (string=
           "https://www.beeminder.com/api/v1/test-path.json"
           (beeminder--create-endpoint "test-path"))))

(ert-deftest beeminder-api-test/can-create-endpoint-with-query-vars ()
  (should (string=
           "https://www.beeminder.com/api/v1/test-path.json?arg=value"
           (beeminder--create-endpoint "test-path" (list :arg "value")))))

(ert-deftest beeminder-api-test/can-build-query-from-list ()
  (should (string=
           "?arg=value"
           (beeminder--build-query (list :arg "value")))))

(ert-deftest beeminder-api-test/can-build-query-from-long-list ()
  (should (string=
           "?arg=value&arg2=another value"
           (beeminder--build-query (list :arg "value"
                                         :arg2 "another value")))))
