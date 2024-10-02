from can_source.can_error import NoTokenException
from can_source.util.option import Option
from can_source.can_ast import MacroResult, TokenTree
from can_source.can_parser import *
from can_source.can_const import *
from can_source.parser_base import ParserFn, new_token_context
from typing import Generator


def match(pattern, tokentrees: Generator) -> Option:
    matched_meta_vars = {}
    matched_meta_repetitions = []
    cur_token_context = new_token_context(tokentrees)
    curF = ParserFn(ctx=cur_token_context)
    if len(pattern) == 0:
        return (
            Option(matched_meta_vars)
            if len([x for x in tokentrees]) == 0
            else Option(None)
        )
    for pat in pattern:
        if isinstance(pat, can_ast.MacroMetaId):
            meta_var_name = pat._id.value
            spec = FragSpec.from_can_token(pat.frag_spec)
            if spec == FragSpec.IDENT:
                ast_node = can_ast.can_exp.IdExp(
                    name=curF.eat_tk_by_kind(TokenType.IDENTIFIER).value
                )
                matched_meta_vars[meta_var_name] = ast_node
            elif spec == FragSpec.STMT:
                ast_node = StatParser(token_context=cur_token_context).parse()
                matched_meta_vars[meta_var_name] = ast_node
            elif spec == FragSpec.EXPR:
                ast_node = ExpParser.from_ParserFn(curF).parse_exp()
                matched_meta_vars[meta_var_name] = ast_node
            elif spec == FragSpec.STR:
                ast_node = can_ast.can_exp.StringExp(
                    s=curF.eat_tk_by_kind(TokenType.STRING).value
                )
                matched_meta_vars[meta_var_name] = ast_node
        elif isinstance(pat, can_ast.MacroMetaRepExp):
            print(pat)
        else:
            try:
                if curF.match_tk(pat):
                    curF.skip_once()
                else:
                    return Option(None)
            except NoTokenException:
                return Option(None)
    return Option(matched_meta_vars)


class CanMacro:
    def __init__(self, name, patterns, alter_blocks) -> None:
        self.name = name
        self.patterns = patterns
        self.alter_blocks = alter_blocks

    def try_expand(self, tokentrees: TokenTree):
        for pat, block in zip(self.patterns, self.alter_blocks):
            match_res = match(pat, (token for token in tokentrees.val))
            if match_res.is_some():
                meta_vars = match_res.unwrap()
                return meta_vars, block
        raise f"Can not expand macro: {self.name}"

    def eval(self, tokentrees: TokenTree) -> MacroResult:
        matched_meta_vars, block = self.try_expand(tokentrees)
        parse_res = MacroResult(matched_meta_vars, block)
        return parse_res
