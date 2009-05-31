目录下的文件说明：

portal.javac.inlude.txt 用于在ant javac 的时候指明哪些类需要编译，这些类是有jspc根据jsp页面生成出来的

portal.webinc.xml 用于将jsp生成的servlet配置到web.xml中

【JSP开发员必读】

新开发的JSP页面，如果是可单独运行的jsp文件，需要修改portal.javac.inlude.txt文件。
可单独运行的jsp文件一般会在portal422\server\default\work\org\apache\jsp目录下生成java/class文件，
如/html/nds/object/inc_single_object.jsp就不是可单独运行的jsp文件。

修改portal.javac.inlude.txt文件时，一般到portal422\server\default\work\org\apache\jsp目录下找到相应文件后，
将文件名拷贝到文件中，注意_005f,org/apache/jspc/html/nds/这样的目录结构

如何在安装环境调试jsp文件？
这种情况发生在部署后程序出现异常的情况，可以有两种处理方法：
1)在jsp文件里放置Log4J调试代码（禁止使用System.out来打印)，Log4J的标识类别一般取jsp文件的名字如 [object.jsp]
2)将jsp文件部署到目标服务器上，删除web.xml里关于mapping的描述后重启，这样jsp将覆盖servlet定义