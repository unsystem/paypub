#include <fstream>
#include <boost/filesystem.hpp>
#include <boost/lexical_cast.hpp>
#include <bitcoin/bitcoin.hpp>
using namespace bc;
namespace fs = boost::filesystem;

typedef std::vector<char> signed_data_chunk;

int main(int argc, char** argv)
{
    if (argc != 3)
    {
        std::cerr << "Usage: pp_start DOCUMENT CHUNKS" << std::endl;
        std::cerr << "Good default for CHUNKS is 100" << std::endl;
        return -1;
    }
    const fs::path document_full_path = argv[1];
    const fs::path doc_path = document_full_path.parent_path();
    const fs::path doc_filename = document_full_path.filename();
    const std::string chunks_str = argv[2];
    size_t chunks = 0;
    try
    {
        chunks = boost::lexical_cast<size_t>(chunks_str);
    }
    catch (const boost::bad_lexical_cast&)
    {
        std::cerr << "pp_start: bad CHUNKS provided." << std::endl;
        return -1;
    }
    const fs::path public_chunks_path =
        doc_path / (doc_filename.native() + "_public_chunks");
    if (!fs::create_directory(public_chunks_path))
    {
        std::cerr << "pp_start: error creating path '"
            << public_chunks_path.native() << "'" << std::endl;
        return -1;
    }
    std::ifstream infile(document_full_path.native(), std::ifstream::binary);
    infile.seekg(0, std::ifstream::end);
    size_t file_size = infile.tellg();
    infile.seekg(0, std::ifstream::beg);
    size_t chunk_size = file_size / chunks;
    std::cout << "Creating " << chunks << " chunks of "
        << chunk_size << " bytes each." << std::endl;
    size_t i = 0;
    while (infile)
    {
        signed_data_chunk buffer(chunk_size);
        infile.read(buffer.data(), chunk_size);
        ++i;
        const fs::path chunk_filename =
            public_chunks_path / 
                (std::string("CHUNK.") + boost::lexical_cast<std::string>(i));
        std::ofstream outfile(chunk_filename.native(), std::ifstream::binary);
        outfile.write(buffer.data(), infile.gcount());
    }
    std::cout << i << " chunks created." << std::endl;
    return 0;
}

