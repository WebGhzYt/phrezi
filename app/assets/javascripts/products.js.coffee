_.execif('.products, .products-index', ->

  for edit in $(".product-edit")
    edit.onclick = (event)->(
      event.preventDefault();
      $(".product-editing").hide()
      $(".product-viewing").show()
      id = $(this).attr("id").replace("product-","")
      $(this).parent().parent().hide()
      $("#product-edit-#{id}").show()
    )

  for edit in $(".category-edit")
    edit.onclick = (event)->(
      event.preventDefault();
      $(".category-editing").hide()
      $(".category-viewing").show()
      id = $(this).attr("id").replace("category-","")
      console.log(id)
      $(this).parent().parent().hide()
      $("#category-edit-#{id}").show()
    )
)
    