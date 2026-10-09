#!/usr/bin/env node
/**
 * PreToolUse hook: todo commit deve sair como cauedev30 <cauefranco01@gmail.com>.
 * Bloqueia tambem qualquer trailer Co-Authored-By do Claude/Anthropic.
 * Entrada: JSON do hook no stdin. Saida: nada (libera) ou JSON de deny.
 */
const { execFileSync } = require('child_process');

const EXPECTED_NAME = 'cauedev30';
const EXPECTED_EMAIL = 'cauefranco01@gmail.com';
const EXPECTED_AUTHOR = EXPECTED_NAME + ' <' + EXPECTED_EMAIL + '>';

let raw = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', (d) => { raw += d; });
process.stdin.on('end', () => {
  try { main(JSON.parse(raw || '{}')); } catch (e) { allow(); }
});

function allow() { process.exit(0); }

function deny(reason) {
  process.stdout.write(JSON.stringify({
    hookSpecificOutput: {
      hookEventName: 'PreToolUse',
      permissionDecision: 'deny',
      permissionDecisionReason: reason
    }
  }));
  process.exit(0);
}

function unquote(s) {
  if (!s) return '';
  s = s.trim();
  if ((s.startsWith('"') && s.endsWith('"')) || (s.startsWith("'") && s.endsWith("'"))) {
    s = s.slice(1, -1);
  }
  return s.trim();
}

// O segmento realmente roda `git ... commit`?
function isGitCommit(segment) {
  const tokens = segment.trim().split(/\s+/).filter(Boolean);
  let i = tokens.findIndex((t) => /(^|[\/])git(\.exe)?$/i.test(t.replace(/^["']|["']$/g, '')));
  if (i === -1) return false;
  const takesValue = ['-c', '-C', '--git-dir', '--work-tree', '--namespace', '--exec-path', '--config-env'];
  for (i += 1; i < tokens.length; i++) {
    const t = tokens[i];
    if (t.startsWith('-')) {
      if (takesValue.includes(t)) i += 1;
      continue;
    }
    return t === 'commit';
  }
  return false;
}

function resolveCwd(cmd, fallback) {
  const m = cmd.match(/^\s*cd\s+(?:\/d\s+)?("[^"]+"|'[^']+'|\S+)/i);
  if (m) return unquote(m[1]);
  return fallback || process.cwd();
}

function main(input) {
  const cmd = input && input.tool_input && input.tool_input.command;
  if (typeof cmd !== 'string' || !cmd.trim()) allow();

  const segments = cmd.split(/&&|\|\||;|\n/);
  const commitSegs = segments.filter(isGitCommit);
  if (commitSegs.length === 0) allow();

  // 1. Claude nunca como co-autor / colaborador
  const coauthor = cmd.match(/co-?authored-by:\s*([^\n"']*)/gi) || [];
  for (const line of coauthor) {
    if (/claude|anthropic/i.test(line)) {
      deny('BLOQUEADO: trailer "' + line.trim() + '". Claude nunca entra como colaborador nos seus projetos. Remova a linha Co-Authored-By e refaça o commit.');
    }
  }

  for (const seg of commitSegs) {
    // 2. variaveis de ambiente GIT_AUTHOR_* / GIT_COMMITTER_*
    const envRe = /(?:^|\s)(GIT_(?:AUTHOR|COMMITTER)_(?:NAME|EMAIL))=("[^"]*"|'[^']*'|\S+)/g;
    let m;
    while ((m = envRe.exec(seg)) !== null) {
      const val = unquote(m[2]);
      const expected = m[1].endsWith('EMAIL') ? EXPECTED_EMAIL : EXPECTED_NAME;
      if (val.toLowerCase() !== expected.toLowerCase()) {
        deny('BLOQUEADO: ' + m[1] + '=' + val + ' tenta commitar com identidade diferente. Único autor permitido: ' + EXPECTED_AUTHOR + '.');
      }
    }

    // 3. git -c user.email=... / -c user.name=...
    const cRe = /(?:^|\s)-c\s+(user\.(?:email|name))=("[^"]*"|'[^']*'|\S+)/gi;
    while ((m = cRe.exec(seg)) !== null) {
      const val = unquote(m[2]);
      const expected = /email/i.test(m[1]) ? EXPECTED_EMAIL : EXPECTED_NAME;
      if (val.toLowerCase() !== expected.toLowerCase()) {
        deny('BLOQUEADO: -c ' + m[1] + '=' + val + ' sobrescreve a identidade do commit. Único autor permitido: ' + EXPECTED_AUTHOR + '.');
      }
    }

    // 4. --author
    const aRe = /--author(?:=|\s+)("[^"]*"|'[^']*'|\S+)/g;
    while ((m = aRe.exec(seg)) !== null) {
      const val = unquote(m[1]);
      const email = (val.match(/<([^>]+)>/) || [])[1] || val;
      const name = val.replace(/\s*<[^>]*>\s*/, '').trim();
      if (email.toLowerCase() !== EXPECTED_EMAIL.toLowerCase() ||
          (name && name.toLowerCase() !== EXPECTED_NAME.toLowerCase())) {
        deny('BLOQUEADO: --author "' + val + '" não é o autor único permitido (' + EXPECTED_AUTHOR + ').');
      }
    }
  }

  // 5. identidade efetiva do repositorio
  const dir = resolveCwd(cmd, input && input.cwd);
  let name, email;
  try {
    email = execFileSync('git', ['-C', dir, 'config', '--get', 'user.email'], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
    name = execFileSync('git', ['-C', dir, 'config', '--get', 'user.name'], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
  } catch (e) {
    // sem git/sem repo/sem identidade configurada
    email = email || '';
    name = name || '';
  }

  if (!email || email.toLowerCase() !== EXPECTED_EMAIL.toLowerCase() ||
      !name || name.toLowerCase() !== EXPECTED_NAME.toLowerCase()) {
    deny(
      'BLOQUEADO: a identidade git deste repositório é "' + (name || '(vazio)') + ' <' + (email || '(vazio)') + '>", ' +
      'e todo commit tem que sair como ' + EXPECTED_AUTHOR + '.\n' +
      'Corrija em ' + dir + ' e tente de novo:\n' +
      '  git config user.name "' + EXPECTED_NAME + '"\n' +
      '  git config user.email "' + EXPECTED_EMAIL + '"'
    );
  }

  allow();
}
