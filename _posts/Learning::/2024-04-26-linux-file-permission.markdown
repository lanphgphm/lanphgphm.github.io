windows filesystem là nhiều cây. mỗi cái ổ C/, D/, hay mỗi lần cắm usb vào là có một cái cây mới. linux filesystem là một và chỉ một cây, bắt đầu từ root folder /

mỗi file trong fs sẽ có một bộ quyền hạn được flag bằng các bits. ban đầu thì unix dùng 7 bit để đánh dấu file permission: 3 bit đầu là read-write-execute power của file owner (và root), 3 bit sau là rwx của các user khác. bit thứ 7 đánh dấu xem file này có được execute với quyền hạn của owner không.

![original linux file permission binary string](/images/linux-file-permission-1.jpg) 

mặc dù ban đầu có 7 bit, trên giao diện người dùng là 7 character, thì most time file permission được biểu diễn bằng 10 character. 1 char đầu là filetype, 3 bộ triplet bit sau đó thì là quyền hạn của owner và root, group, và other users, respectively. vì vậy nên sau này khi dùng đến tận 16bit để flag file permission ở low level, thì lúc render lên high level, người ta vẫn giữ nguyên cái 10-character format.

![new linux file permission binary string](/images/linux-file-permission-2.jpg) 

đây cũng tính là "backwards compatibility", nhưng này là đang cố compatible với user cũ lâu năm nhiều hơn là với máy =))

ảnh 3 là mình vẽ lại các layer of abstractions của các file trong một directory. directory là một file đặc biệt lưu i-number (index number), i-number này đem vào tìm trong i-list, thì cái entry i-list[i-number] sẽ chưa inode của file. inode sẽ giúp hệ điều hành biết là file này được lưu ở những phân vùng nào của ổ đĩa (phần cứng), để nó đến đấy lấy dữ liệu cho user đọc/viết/chạy file.

![file storage in a directory](/images/linux-file-permission-3.jpg)
