khi chạy ubuntu docker container, chính xác là mình đang chạy cái gì vậy?

nếu chạy ubuntu virtual machine, thì là mình đang chạy hệ điều hành ubuntu, kernel linux, trong một môi trường được cô lập và giám sát bởi hypervisor.

nếu chạy mysql trong docker container, thì là mình đang chia sẻ tài nguyên của hệ điều hành máy chủ (ví dụ như của tôi là arch), nhưng cái container nó blind với tài nguyên nằm ngoài những gì nó được cho phép nhìn thấy, và nó tưởng nó có filesystem riêng. mọi tính năng như kiểu task scheduler, package manager, v.v. đều là do hệ điều hành máy chủ quản lý.

nếu container không được quyết định hệ điều hành và không có kernel của riêng mình, thì tại sao concept về "ubuntu docker container" lại tồn tại và không contradictory? ubuntu docker container không thể có kernel, chắc chắn nó phải dùng kernel của host OS, nhưng tại sao nó có package manager, update và upgrade được? nó share kernel nhưng cô lập hết process và tài nguyên à?

"tại sao khái niệm ubuntu docker container tồn tại mà không contradictory?"

đầu tiên, lý do mình có câu hỏi này là vì mình hiểu container và virtual machine là hai khái niệm khác hẳn nhau. đúng là có sự khác biệt nhưng có rất nhiều chỗ giống, mình quá tập trung vào cái khác nên mới thấy ý tưởng về một container giả lập một hệ điều hành là contradictory.


2 định nghĩa mình tự viết lại theo cách hiểu:

hệ điều hành là gì? hệ điều hành là phần mềm quản lý tài nguyên và điều phối tiến trình. chương trình quan trọng nhất của hệ điều hành là hạt nhân (kernel), kernel quản lý memory (space), quản lý các process chạy trên máy, quản lý các thiết bị gắn vào cái máy (bàn phím, màn hình, chuột).

![operating system illustration](/images/what-is-ubuntu-container-1.jpg)

container là gì? container là một nhóm các process bị cô lập (có vùng bộ nhớ riêng, không thể access (đọc, viết, chạy) ra các vùng nhớ bên ngoài những gì nó được cấp). một container chạy như một process bình thường trên hệ điều hành host, hệ điều hành host biết là container tồn tại cùng với tất cả các process khác tồn tại. container không biết có process khác tồn tại trên cùng cái máy chủ mà nó đang chạy trên.

![virtual machine vs. container illustration](/images/what-is-ubuntu-container-2.jpg)

câu trả lời cho câu hỏi: một docker image có thể appear như một hệ điều hành ảo, nhưng thực ra docker image này đang share kernel với host. một cái virtual machine sẽ dùng kernel của riêng nó (load kernel mới bên trong kernel của host OS), và hypervisor (nằm trên phần cứng) sẽ chia tài nguyên cho hai kernel. một cái container sẽ chạy kernel đã có sẵn trên máy chủ, và tài nguyên chia cho container và các process còn lại bởi hệ điều hành (không cần hypervisor).

ubuntu docker container mà chạy trên archlinux thì có nghĩa là ubuntu container và archlinux đang cùng share một linux kernel. điều đáng chú ý là linux kernel có khả năng cô lập tài nguyên (bằng namespace và cgroups), docker, kubernettes, hay bất cứ một công nghệ đóng container nào khác cũng chỉ đang khai thác các tính năng đã có sẵn, được cung cấp bởi linux kernel này thôi. điều này có nghĩa là một docker OS container có chạy tốt được không hoàn toàn phụ thuộc vào việc hệ điều hành nó cố chạy có tương thích với kernel của máy chủ hay không.

một docker OS container có chạy tốt hay không hoàn toàn phụ thuộc vào việc hệ điều hành container này muốn chạy có tương thích với kernel của hệ điều hành máy chủ hay không.

ví dụ: centOS 5 và 6 chỉ support bash với kernel version nhỏ hơn 4.19. nếu máy chủ dùng kernel bản >= 4.19, rồi host một cái docker container cho centOS 5, rồi trong container này chạy lệnh /bin/bash, thì sẽ không thể chạy được bash trong container này.

ví dụ phổ biến hơn: nếu đòi chạy docker container cho ubuntu trên windows : D thì khỏi chạy được luôn. kiến trúc kernel của linux là monolithic kernel, kiến trúc kernel của windows là hybrid kernel, chắc chắn sẽ không compatible ở nhiều chỗ, chạy là break nhanh luôn. nhưng cái này không đặc biệt gì với docker OS container. docker container nào cũng cần linux để chạy, nên nếu mình chạy được docker trên máy windows là docker đã tự bật máy áo linux lên trong windows, rồi chạy docker container trong chính máy ảo linux đó. nếu dùng hệ điều hành windows mà hoàn toàn không support máy ảo (tức không có hypervisor--windows cũ quá có thể bị) thì là không chạy được docker tí nào luôn.

vậy nên chốt lại: ubuntu docker container bao gồm các process được cô lập y như các process khác trên máy. docker container càng compatible với kernel máy chủ càng tốt, còn nếu không compatible đến mức không chấp nhận được thì phải chạy docker trong máy ảo.
