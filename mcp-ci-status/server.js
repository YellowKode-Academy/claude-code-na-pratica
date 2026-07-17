const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');
const { CallToolRequestSchema, ListToolsRequestSchema } = require('@modelcontextprotocol/sdk/types.js');

const CI_API_TOKEN = process.env.CI_API_TOKEN;

const server = new Server(
  { name: 'ci-status', version: '1.0.0' },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: 'get_pr_checks',
      description: 'Consulta o status de todos os checks de CI de um pull request pelo número',
      inputSchema: {
        type: 'object',
        properties: {
          pr_number: {
            type: 'integer',
            description: 'Número do Pull Request'
          }
        },
        required: ['pr_number']
      }
    },
    {
      name: 'get_job_log',
      description: 'Retorna o log completo de um job de CI pelo ID, para investigar falhas',
      inputSchema: {
        type: 'object',
        properties: {
          job_id: {
            type: 'string',
            description: 'ID do job de CI retornado por get_pr_checks'
          }
        },
        required: ['job_id']
      }
    }
  ]
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'get_pr_checks') {
    // Em produção: substituir pela chamada real à API do seu serviço de CI
    // usando CI_API_TOKEN para autenticação
    return {
      content: [{
        type: 'text',
        text: JSON.stringify({
          pr_number: args.pr_number,
          checks: [
            { name: 'unit-tests', status: 'success', job_id: `job-${args.pr_number}-001` },
            { name: 'integration-tests', status: 'success', job_id: `job-${args.pr_number}-002` },
            { name: 'lint', status: 'success', job_id: `job-${args.pr_number}-003` }
          ]
        })
      }]
    };
  }

  if (name === 'get_job_log') {
    // Em produção: buscar log real do job na API do CI
    return {
      content: [{
        type: 'text',
        text: `Log do job ${args.job_id}:\n[INFO] Iniciando execução\n[INFO] Todos os passos concluídos com sucesso\n[INFO] Tempo total: 47s`
      }]
    };
  }

  throw new Error(`Tool desconhecida: ${name}`);
});

const transport = new StdioServerTransport();
server.connect(transport);
