---
layout: post_with_category 
title: "Insecure Programming" 
date: 2024-06-13
categories: Learning 
---

`printf()` của C lấy 2 argument chính, `printf(format_string, string_pointer_1, string_pointer_2...)`. `format_string` là cái `%s %d`, theo sau đó là một đống pointers đến các thứ cần đc inject vào string.

các pointer kia được bỏ vào stack và `printf()` sẽ pop đủ số param trong stack sao cho fill đc hết các % trong `format_string`.

nếu `format_string` không được supply đủ số pointer thì nó cũng chả biết, nó cứ nhìn vào format string và pop cho đủ thôi. vậy nêu bây giờ mình `printf(userInput)` mà `userInput = "%x.%x.%x.%x.%x"` là mình lấy đc 5 biến trong stack của chương trình ra đọc (mà đáng ra mình ko đc đọc).

chương trình bố láo bố lếu rất hay. + 10 điểm nghịch ngợm.

![Insecure programming example](/images/insecure-programming.jpg) 
