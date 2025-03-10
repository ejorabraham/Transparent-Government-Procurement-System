;; Tender Publication Contract

(define-data-var next-tender-id uint u0)

(define-map tenders
  { tender-id: uint }
  {
    title: (string-ascii 100),
    description: (string-utf8 1000),
    deadline: uint,
    status: (string-ascii 20)
  }
)

(define-public (publish-tender (title (string-ascii 100)) (description (string-utf8 1000)) (deadline uint))
  (let ((new-tender-id (var-get next-tender-id)))
    (map-set tenders
      { tender-id: new-tender-id }
      {
        title: title,
        description: description,
        deadline: deadline,
        status: "open"
      }
    )
    (var-set next-tender-id (+ new-tender-id u1))
    (ok new-tender-id)
  )
)

(define-read-only (get-tender (tender-id uint))
  (map-get? tenders { tender-id: tender-id })
)

(define-public (close-tender (tender-id uint))
  (let ((tender (unwrap! (get-tender tender-id) (err u404))))
    (asserts! (is-eq (get status tender) "open") (err u403))
    (ok (map-set tenders
      { tender-id: tender-id }
      (merge tender { status: "closed" })
    ))
  )
)

