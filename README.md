# Chikatetsu

地下鉄とは路線の大部分が地下空間に存在する鉄道である。主に都市高速鉄道として建設される。 Lua + D

## 起源

地下鉄(Chikatetsu, 下简称CKTT)这个名字源自初次讨论项目时开发者们恰好在Subway吃饭, 于是便以Subway的本义, 即地铁的日语名命名了项目~

之后在纠结开发语言时某开发者曾建议使用基于 Erlang 的新兴语言 Elixir, 并曾初始化出大致结构, 即原版的 Chikatetsu, 后来其他开发者表示对函数式语言不感兴趣.. 于是转向采用 Lua + D 的方式.

## 整体架构

CKTT整体分为三个部分: CFI, API, CLI.

### CFI: CKTT Foundation Interface

CFI 是整个数据库架构的最底层, 主要负责缓存的管理和底层文件的存储管理.

主要文件包括 `buffer.d`

### API: Application Programming Interface

API 是数据库架构的中层也是工作量最多的层, 其各个组件分别负责表, Schema信息, 记录, 索引和数据库元信息等的管理.

不同的组件主要划分为: `index.d`, `meta.d`, `record.d`, `schema.d`, `table.d`

(todo)

### CLI: Command Line Interface

CLI 处于整个架构顶层, 其负责整合所有下两层的接口, 并提供与用户交互的界面. 同时需要提供对用户输入的语法检查等等功能.

主要文件: `interp.d`
