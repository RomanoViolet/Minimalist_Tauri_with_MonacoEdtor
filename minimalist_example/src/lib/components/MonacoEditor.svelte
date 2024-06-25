<script lang="ts">
  import { onMount } from 'svelte';
  import * as monaco from 'monaco-editor';
  import { createMonacoEditor, setupMonaco } from '$lib/components/monaco'; // Adjust the import path

  let editorContainer: HTMLDivElement;
  let editor: monaco.editor.IStandaloneCodeEditor;

  onMount(() => {
    setupMonaco();
    editor = createMonacoEditor(editorContainer, {
      value: '',
      language: 'javascript',
      theme: 'vs-dark'
    });

    return () => {
      if (editor) {
        editor.dispose();
      }
    };
  });
</script>

<div class="editor-container" bind:this={editorContainer}></div>

<style>
  .editor-container {
    width: 100%;
    height: 100vh; /* Adjust as necessary */
    background-color: #23879e;
  }
</style>
