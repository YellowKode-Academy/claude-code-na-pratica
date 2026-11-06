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
      description: 'Gets the status of every CI check on a pull request by number',
      inputSchema: {
        type: 'object',
        properties: {
          pr_number: {
            type: 'integer',
            description: 'Pull Request number'
          }
        },
        required: ['pr_number']
      }
    },
    {
      name: 'get_job_log',
      description: 'Returns the full log of a CI job by ID, to investigate failures',
      inputSchema: {
        type: 'object',
        properties: {
          job_id: {
            type: 'string',
            description: 'CI job ID returned by get_pr_checks'
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
    // In production: replace with the real call to your CI service's API
    // using CI_API_TOKEN for authentication
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
    // In production: fetch the job's real log from the CI API
    return {
      content: [{
        type: 'text',
        text: `Log for job ${args.job_id}:\n[INFO] Starting run\n[INFO] All steps completed successfully\n[INFO] Total time: 47s`
      }]
    };
  }

  throw new Error(`Unknown tool: ${name}`);
});

const transport = new StdioServerTransport();
server.connect(transport);
