import { resolveResource } from '@tauri-apps/api/path';
import * as monaco from 'monaco-editor';

async function createWorker(path: string): Promise<Worker> {
  const resourcePath = await resolveResource(path);
  return new Worker(resourcePath, { type: 'module' });
}

export async function setupMonaco(): Promise<any> {
  const editorWorker = await createWorker('vs/editor/editor.main.js');
  const cssWorker = await createWorker('vs/language/css/css.worker.js');
  const htmlWorker = await createWorker('vs/language/html/html.worker.js');

  self.MonacoEnvironment = {
    getWorker(_, label: string) {
      if (label === 'css') return cssWorker;
      if (label === 'html') return htmlWorker;
      return editorWorker;
    },
    baseUrl: new URL('node_modules/monaco-editor/min', import.meta.url).href
  };
}

export function createMonacoEditor(
  elementId: HTMLElement,
  options: monaco.editor.IStandaloneEditorConstructionOptions
): monaco.editor.IStandaloneCodeEditor {
  return monaco.editor.create(elementId, options);
}
