本目录提供soc_lite的目录。

目录结构：
   +--rtl/             : soc_lite的rtl源码，不包含xilinx IP，CPU为gs132，
   |                      
   |--sim/             : 仿真使用的文件，当前为空
   |
   |--soft/            : 软件编译目录，需在Linux下使用交叉编译工具链编译
   |    |--memory_game/    : 记忆游戏的编译目录
   |    |--func_test/      : 功能测试的编译目录，当前为空
   |    |--coramark/       : 性能测试coremark的编译目录，当前为空
   |
   |--vivado_xpr/      : vivado2017.1的工程总目录
        |--memory_game/    : 记忆游戏的vivado工程
        |        |---project_1  : vivado2017.1的工程脚本目录，可直接打开
        |        |---xilinx_ip  : 记忆游戏工程需使用的xilinx IP存放目录
        |--func_test/      : 功能测试的vivado工程，当前为空
        |--coramark/       : 性能测试coremark的vivado工程，当前为空
        |--soc_lite.xdc    : 所有工程共用的约束文件
