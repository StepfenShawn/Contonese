block ::= {stat} [retstat]
stat ::= ';' |
      | '饮茶先啦'
      | '收工'
      | 'Share下' idlist
      | '介紹返' varlist '係' (explist | class_def_stmt)
      | '介紹返' '=>' assignblock '先啦'
      | '介紹返' function_def_stmt
      | printstmt ['@' idlist]
      | importstmt
      | functioncall ['@' idlist]
      | '落操场玩跑步' block '玩到' exp '为止'
      | lambda_functoindef ['@' idlist]
      | '&&' idlist '喺' explist '=>' '{' block '}'
      | id '从' exp '行到' exp block '到步'
      | '起底' args
      | '如果' exp '嘅话' '->' '{' block '}' [定係 exp 嘅话 '->' '{' block '}'] ['唔係嘅话' '->' '{' block '}']
      | 睇L住 id '=>' '{' matchblock '}'
      | '掟个' id '嚟睇下'
      | '谂下' args
      | '落Order' args
      | '有条仆街叫' ['|'] id ['|']
      | '顶你' '=>' ['|'] id ['|'] exp
      | '丢你' '=>' ['|'] id ['|']
      | '嗌' exp 过嚟估下 '=>' exp
      | '老作一下' '=>' '{' exp_list '}'
      | exp 拍住上 '=>' ['|'] id ['|']
      | exp 啦!
      | 好心 exp 啦!
      | try_stmt
      | class_def_stmt

function_def_stmt ::=  '$' id [parlist] '點部署' block '搞掂'

lambda_functoindef ::= '$$' [parlist] '->' block '搞掂'

try_stmt ::= '执嘢' '=>' '{' block '}' ['揾到' exp '嘅话' '->' '{' block '}']* ['执手尾' '-> '{' block '}']

class_def_stmt ::= '' '{' exp [佢個老豆叫 idlist] class_def_block '}'

class_def_block ::= '佢嘅' classvarlist 係 explist
              | '佢識得' id [parlist] '=>' '{' block '}'
              | '佢有啲咩' '=>' '{' assignblock '}'

retstat ::= '还数' [explist]

exp ::= null
    | false
    | true
    | Numeral
    | LiteralString
    | listconstructor
    | mapconstructor
    | lambda_functoindef
    | prefixexp
    | exp binop exp
    | unop exp
    | '<*>'
    | '若然' exp "->" exp "唔係咁就" "=>" exp

prefixexp ::= var
          | '|' exp '|'
          | '(' exp ')'
          | '<|' id '|>'
          | functioncall

var ::= id
    | prefixexp '[' exp ']'
    | prefixexp '->' id
    | prefixexp '.' id 

functioncall ::= prefixexp '下' '->' args
             | prefixexp '(' args ')'


listconstructor ::= '[' {fieldlist} ']'
mapconstructor ::= '{' {fieldlist} '}'

fieldlist ::= field {',' field} [',']

field ::= '[' exp ']'
        | '{' exp '}'
        | exp

printstmt ::= '畀我睇下' args '點樣先'

importstmt ::= '使下' idlist
            | '使下' '|' idlist '|'

explist ::= exp {',' exp}

varlist ::= var {',' var}

idlist ::= id {',' id}
        | '|' id {',' id} '|'

parlist ::= idlist {'<*>'}
          | '<*>  

args ::= '|' {explist} '|'
      | exp

binop ::= '+' | '-' | '*' | '/' | '^' | '%' | '<->' | 
         '<' | '<=' | '>' | '>=' | '==' | '!=' | and | or
         '>>' | '<<' | '==>'

unop ::= not

assignblock ::= varlist '係' explist [ assignblock ]

matchblock ::= '撞见' exp '=>' '{' block '}' [ matchblock ]